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
local ToggleGui = require(script.Parent.ToggleGui)
local Sound = require(script.Parent.Sounds)
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local cursor = game:GetService("ReplicatedStorage").ClientAssets.Models:WaitForChild("Cursor")
local digEvent = game.ReplicatedStorage.Events.Dig
-- local placeEvent = game.ReplicatedStorage.Events.Place
local TerrainMaterials = require(game.ReplicatedStorage.TerrainMaterials)

local offset = Vector3.new(2, 2, 2)
local reachDistance = 12
BuildMode.SelectedMaterial = nil

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

		material = TerrainMaterials:GetMaterial(material)

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

				if occupancy == 1 or material ~= BuildMode.SelectedMaterial then
					cell = Terrain:WorldToCellPreferEmpty(raycast.Position)
					pos = Terrain:CellCenterToWorld(cell.X, cell.Y, cell.Z)
					local _, occ = Terrain:ReadVoxels(Region3.new(pos - offset, pos + offset), 4)

					if occ ~= 0 then
						return
					end
				end
			end

			--if not cell then

			--end

			local pos = Terrain:CellCenterToWorld(cell.X, cell.Y, cell.Z)

			if mode == "Dig" then
				local material, occupancy = Terrain:ReadVoxels(Region3.new(pos - offset, pos + offset), 4)
				material, occupancy = material[1][1][1], occupancy[1][1][1]

				UpdateVoxelGui(material, occupancy)

				if occupancy <= 0 then
					pos = nil
				end
			end

			if cursor and pos then
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

local function findTool(path)
	local name = path[#path]

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

	return TerrainMaterials:GetMaterial(material[1][1][1]), occupancy[1][1][1]
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
		material = TerrainMaterials:GetMaterial(material)

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
		wait(cooldown)
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
		if not BuildMode.SelectedMaterial then
			break
		end
		if mode ~= "Build" then
			break
		end
		if cursor.Parent ~= workspace then
			break
		end

		local material, occupancy = getVoxel()

		if (material ~= BuildMode.SelectedMaterial and occupancy > 0) and material ~= Enum.Material.Air then
			break
		end

		-- TODO
		-- Place material
	end

	-- No longer running
	running = false
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
		mode = "Dig"
	elseif input.KeyCode == Enum.KeyCode.Two and not ignored and BuildMode.Enabled then
		-- Set mode to build if pressing 2
		mode = "Build"
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		holding = false
	end
end)

return BuildMode
