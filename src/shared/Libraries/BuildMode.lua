local BuildMode = {}
local Terrain = workspace.Terrain
local player = game.Players.LocalPlayer
local backpack = player.Backpack
local playerGui = player:WaitForChild("PlayerGui")
local gui = playerGui:WaitForChild("BuildMode")
local digbar = gui.Dig.Bar
local digmaterial = gui.Dig.Material
local digpercent = gui.Dig.Percent
local digtier = gui.Dig.Tier
local digcooldown = gui.Cooldown
local materials = gui.Materials.Container
local ToggleGui = require(script.Parent.ToggleGui)
local Sound = require(script.Parent.Sounds)
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local clientAssets = game:GetService("ReplicatedStorage").ClientAssets
local cursor = clientAssets.Models:WaitForChild("Cursor")
local materialButton = clientAssets.GUI:WaitForChild("MaterialButton")
local digEvent = game.ReplicatedStorage.Events.Dig
local placeEvent = game.ReplicatedStorage.Events.Place
local TerrainMaterials = require(game.ReplicatedStorage.Libraries.TerrainMaterials)
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local _, dataId = DataManager:Get(player):await()
local data = ClientComm:GetProperty(dataId)
data:OnReady():await()
local inventory = ClientComm:GetProperty(data:Get().Inventory)
inventory:OnReady():await()

local selectedProperties = {
	["BackgroundColor3"] = Color3.fromRGB(45, 38, 36),
	["BorderColor3"] = Color3.fromRGB(214, 181, 96),
	["BorderSizePixel"] = 4,
	["ZIndex"] = 10,
}

local deselectedProperties = {
	["BackgroundColor3"] = Color3.fromRGB(21, 18, 17),
	["BorderColor3"] = Color3.fromRGB(42, 37, 34),
	["BorderSizePixel"] = 3,
	["ZIndex"] = 1,
}

local offset = Vector3.new(2, 2, 2)
local reachDistance = 12
BuildMode.SelectedItem = nil
BuildMode.PlacementSize = 0.25

local blacklist = { "Hotbar" }
local enabled = {}

local function truncate(number)
	local num = tostring(number)
	local place = string.find(num, "%.")

	if place then
		return string.sub(num, 1, place + 2)
	else
		return num
	end
end

local function hideOtherGui()
	for _, v in pairs(blacklist) do
		local ui = playerGui:WaitForChild(v, 4)

		if ui then
			if ui.Enabled then
				enabled[v] = true
			else
				enabled[v] = false
			end

			ToggleGui.makeTransparent(ui)
			ToggleGui:Blacklist(ui)
		else
			warn("GUI not found: " .. v)
		end
	end
end

local function showOtherGui()
	for _, v in pairs(blacklist) do
		local ui = playerGui:WaitForChild(v, 4)

		if ui then
			if enabled[v] then
				ToggleGui.makeOpaque(ui)
			end

			ToggleGui:RemoveBlacklist(ui)
		else
			warn("Gui not found: " .. v)
		end
	end
end

local function getCharacters()
	local characters = {}

	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Character then
			table.insert(characters, p.Character)
		end
	end

	return characters
end

local function castMouse()
	local camera = workspace.CurrentCamera
	local mpos = UIS:GetMouseLocation()
	local ray = camera:ViewportPointToRay(mpos.X, mpos.Y)

	local params = RaycastParams.new()
	params.IgnoreWater = true
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = getCharacters()

	return workspace:Raycast(ray.Origin, ray.Direction * 64, params)
end

local mode = "Dig"

local normalColor = Color3.fromRGB(255, 255, 255)
local unharvestableColor = Color3.fromRGB(255, 0, 0)

local function DisableVoxelGui()
	gui.Dig.Visible = false
	digcooldown.Visible = false
end

local function UpdateVoxelGui(material, occupancy)
	if occupancy <= 0 or cursor.Parent ~= workspace then
		DisableVoxelGui()
	else
		gui.Dig.Visible = true
		digcooldown.Visible = true

		material = TerrainMaterials:GetMaterial(material.Name)

		digbar.Size = UDim2.new(occupancy, 0, 1, 0)
		digmaterial.Text = material.Material.Name
		digpercent.Text = truncate(occupancy * 100) .. "%"
		digtier.Text = "Tier " .. material.Tier

		local _, harvestable = material:GetDamage(player)

		if harvestable then
			digtier.TextColor3 = normalColor
			digmaterial.TextColor3 = normalColor
		else
			digtier.TextColor3 = unharvestableColor
			digmaterial.TextColor3 = unharvestableColor
		end
	end
end

local function UpdateCursor()
	local raycast = castMouse()
	local character = player.Character

	if raycast and character then
		local root = character.HumanoidRootPart

		if (raycast.Position - root.Position).Magnitude < reachDistance then
			local cell

			if mode == "Dig" then
				cell = Terrain:WorldToCellPreferSolid(raycast.Position)
			else
				cell = Terrain:WorldToCellPreferSolid(raycast.Position)
				local pos = Terrain:CellCenterToWorld(cell.X, cell.Y, cell.Z)
				local material, occupancy = Terrain:ReadVoxels(Region3.new(pos - offset, pos + offset), 4)
				occupancy = occupancy[1][1][1]
				material = material[1][1][1]

				local mat

				if BuildMode.SelectedItem then
					mat = BuildMode.SelectedItem.Name
				end

				if occupancy == 1 or (material.Name ~= mat and occupancy > 0) then
					cell = Terrain:WorldToCellPreferEmpty(raycast.Position)
					pos = Terrain:CellCenterToWorld(cell.X, cell.Y, cell.Z)
					local _, occ = Terrain:ReadVoxels(Region3.new(pos - offset, pos + offset), 4)

					occ = occ[1][1][1]

					if occ ~= 0 then
						if cursor.Parent == workspace then
							cursor.Parent = script
						end

						DisableVoxelGui()

						return
					end
				end
			end

			local pos = Terrain:CellCenterToWorld(cell.X, cell.Y, cell.Z)

			if mode == "Dig" then
				local material, occupancy = Terrain:ReadVoxels(Region3.new(pos - offset, pos + offset), 4)
				material, occupancy = material[1][1][1], occupancy[1][1][1]

				UpdateVoxelGui(material, occupancy)

				if occupancy <= 0 then
					pos = nil
				end
			end

			if pos then
				if cursor.Parent == script then
					cursor.Parent = workspace
				end

				cursor.Position = pos
			else
				if cursor.Parent == workspace then
					cursor.Parent = script
					DisableVoxelGui()
				end
			end
		else
			if cursor.Parent == workspace then
				cursor.Parent = script
				DisableVoxelGui()
			end
		end
	else
		if cursor.Parent == workspace then
			cursor.Parent = script
			DisableVoxelGui()
		end
	end
end

BuildMode.Enabled = false

function BuildMode:Enable()
	if not BuildMode.Enabled then
		BuildMode.Enabled = true
		ToggleGui.makeOpaque(gui)

		hideOtherGui()

		cursor.Parent = workspace

		RS:BindToRenderStep("BuildModeUpdate", 1000, UpdateCursor)
	end
end

function BuildMode:Disable()
	if BuildMode.Enabled then
		BuildMode.Enabled = false
		ToggleGui.makeTransparent(gui)

		showOtherGui()

		cursor.Parent = script
		cursor:PivotTo(CFrame.new(0, 10000, 0))

		RS:UnbindFromRenderStep("BuildModeUpdate")

		if player.Character then
			player.Character.Humanoid:UnequipTools()
		end
	end
end

local soundgroups = {
	{
		{ "Grass", "Ground", "Mud", "Snow", "Sand", "LeafyGrass", "Cobblestone" },
		{
			{ "Breaking", "Ground", "dirt1" },
			{ "Breaking", "Ground", "dirt2" },
			{ "Breaking", "Ground", "dirt3" },
			{ "Breaking", "Ground", "dirt4" },
			{ "Breaking", "Ground", "dirt5" },
			{ "Breaking", "Ground", "dirt6" },
			{ "Breaking", "Ground", "dirt7" },
		},
	},
	{
		{
			"Ice",
			"Rock",
			"Basalt",
			"Salt",
			"Slate",
			"Marble",
			"Pavement",
			"Asphalt",
			"Glacier",
			"Brick",
			"Concrete",
			"Limestone",
			"Sandstone",
			"CrackedLava",
		},
		{
			{ "Breaking", "Mining", "rock1" },
			{ "Breaking", "Mining", "rock2" },
			{ "Breaking", "Mining", "rock3" },
			{ "Breaking", "Mining", "rock4" },
			{ "Breaking", "Mining", "metal1" },
			{ "Breaking", "Mining", "metal2" },
			{ "Breaking", "Mining", "metal3" },
		},
	},
}

local function playSound(material)
	local sounds

	for _, group in pairs(soundgroups) do
		for _, mat in pairs(group[1]) do
			if material == mat then
				sounds = group[2]
				break
			end
		end

		if sounds then
			break
		end
	end

	if sounds then
		Sound:Play(sounds[math.random(1, #sounds)])
	else
		Sound:Play({ "Generic", "error3" })
	end
end

local function findTool(name)
	if backpack:FindFirstChild(name) then
		return backpack[name]
	elseif player.Character:FindFirstChild(name) then
		return player.Character[name]
	end
end

local db_next = 0

local function debounce()
	if tick() >= db_next then
		return true
	end
end

local TweenService = game:GetService("TweenService")

local function cooldownAnim(cd)
	digcooldown.Size = UDim2.new(0, 0, 0.005, 0)

	local endInfo = { Size = UDim2.new(0.2, 0, 0.005, 0) }
	local info = TweenInfo.new(cd, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(digcooldown, info, endInfo):Play()
end

local holding = false
local running = false

local function getVoxel()
	local pos = cursor.Position

	local region = Region3.new(pos - offset, pos + offset)
	local material, occupancy = Terrain:ReadVoxels(region, 4)

	if material[1][1][1] == Enum.Material.Air then
		return
	end

	return TerrainMaterials:GetMaterial(material[1][1][1].Name), occupancy[1][1][1]
end

local function loopDig()
	-- Running loop
	running = true

	while holding do
		-- Safety checks
		if not BuildMode.Enabled then
			break
		end
		if not player.Character then
			break
		end
		if mode ~= "Dig" then
			break
		end
		if cursor.Parent ~= workspace then
			break
		end

		-- Get material
		local material = getVoxel()
		if material.Material == Enum.Material.Air or not material then
			break
		end

		-- Play material sound
		playSound(material.Name)

		-- Get TerrainMaterial object
		material = TerrainMaterials:GetMaterial(material.Name)

		-- Find tool and get cooldown
		local tool = findTool(material.Tool)
		local _, _, cooldown = material:GetDamage(player)

		-- Set debounce
		db_next = tick() + cooldown

		-- Unequip tools (will re-equip after if needed)
		local humanoid: Humanoid = player.Character.Humanoid
		humanoid:UnequipTools()

		-- Equip tool if found
		if tool then
			humanoid:EquipTool(tool)
		end

		-- Send request to server
		local success = digEvent:InvokeServer(cursor.Position)

		-- Play error sound and end loop if unsuccessful
		if not success then
			Sound:Play({ "Generic", "error3" })
			break
		end

		-- Animate bar and wait until the cooldown finishes
		cooldownAnim(cooldown)
		task.wait(cooldown)
	end

	-- No longer running
	running = false
end

local function loopPlacement()
	-- Running loop
	running = true

	while holding do
		-- Safety Checks
		if not BuildMode.Enabled then
			break
		end
		if not player.Character then
			break
		end
		if not BuildMode.SelectedItem then
			Sound:Play({ "Generic", "error3" })
			break
		end
		if mode ~= "Place" then
			break
		end
		if cursor.Parent ~= workspace then
			break
		end

		local cooldown = (BuildMode.PlacementSize * 2) + 0.5

		-- Set debounce
		db_next = tick() + cooldown

		local material, occupancy = getVoxel()

		if material then
			if (material.Name ~= BuildMode.SelectedItem.Name and occupancy > 0) and material ~= Enum.Material.Air then
				break
			end
		end

		local pos = cursor.Position

		playSound(BuildMode.SelectedItem.Name)

		local index = table.find(inventory:Get(), BuildMode.SelectedItem.Id)

		if not index then
			break
		end

		local success = placeEvent:InvokeServer(pos, index, BuildMode.PlacementSize)

		if not success then
			Sound:Play({ "Generic", "error3" })
			break
		end

		-- Animate bar and wait until the cooldown finishes
		cooldownAnim(cooldown)
		task.wait(cooldown)
	end

	-- No longer running
	running = false
end

local selectedButton = gui.Mode.Dig

local function setMode(new)
	if new == mode then
		return
	end

	if selectedButton then
		for i, v in pairs(deselectedProperties) do
			selectedButton[i] = v
		end
	end

	local button = gui.Mode[new]

	for i, v in pairs(selectedProperties) do
		button[i] = v
	end

	mode = new
	selectedButton = button
end

-- Connect function on input
UIS.InputBegan:Connect(function(input, ignored)
	-- Check if not ignored and left click
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not ignored then
		-- Set holding down left click
		holding = true

		-- Check if cooldown ended, not currently running, and in dig mode
		if debounce() and not running and mode == "Dig" then
			-- Loop until player releases their mouse button
			loopDig()
		elseif debounce() and not running then
			-- Loop until mouse button released
			loopPlacement()
		end
	elseif input.KeyCode == Enum.KeyCode.One and not ignored and BuildMode.Enabled then
		-- Set mode to dig if pressing 1
		setMode("Dig")
	elseif input.KeyCode == Enum.KeyCode.Two and not ignored and BuildMode.Enabled then
		-- Set mode to build if pressing 2
		setMode("Place")
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		holding = false
	end
end)

local selected

local function setButton(item)
	local button = materials:FindFirstChild(item.Id)
	local isNew = false

	if not button then
		button = materialButton:Clone()
		isNew = true
	end

	button.Name = item.Id
	button.Image = item.Image
	button.Amount.Text = truncate(item.Amount)
	button.Title.Text = item.Name

	if isNew then
		button.Parent = materials

		button.Activated:Connect(function()
			if not item.Id then
				warn("Item is deleted.")
				return
			end

			local exists = table.find(inventory:Get(), item.Id)

			if not exists then
				warn("Item not found.")
				return
			end

			Sound:Play({ "Generic", "click1" })

			if selected then
				if selected.Parent then
					selected.Title.FontFace = Font.fromEnum(Enum.Font.SourceSans)
					selected.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end

			button.Title.FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
			button.Title.TextColor3 = Color3.fromRGB(255, 255, 0)

			selected = button

			BuildMode.SelectedItem = item
		end)
	end
end

local function updateInventory()
	local inv = inventory:Get()

	for _, button in pairs(materials:GetChildren()) do
		if button:IsA("UIGridStyleLayout") then
			continue
		end

		local found = false

		for _, v in pairs(inv) do
			if v == button.Name then
				found = true
			end
		end

		if not found then
			button:Destroy()
		end
	end

	for i, id in pairs(inv) do
		if not tonumber(i) then
			continue
		end

		local property = ClientComm:GetProperty(id)

		if not property:IsReady() then
			property:OnReady():await()
		end

		local item = property:Get()

		if item.Type == "TerrainMaterial" then
			setButton(item)
		end
	end
end

inventory.Changed:Connect(updateInventory)

return BuildMode
