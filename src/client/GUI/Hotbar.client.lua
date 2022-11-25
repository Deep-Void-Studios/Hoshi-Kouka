local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

Knit.OnStart():await()

local players = game:GetService("Players")
local player = players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar")
local container = gui:WaitForChild("container")

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local BuildMode = require(RS.Libraries.BuildMode)
local sound = require(RS.Libraries.Sounds)
local backpack = player.Backpack

local DataManager = Knit.GetService("DataManager")
local _, dataId = DataManager:Get(player):await()
local data = ClientComm:GetProperty(dataId)
data:OnReady():await()
local equipment = ClientComm:GetProperty(data:Get().Equipment)
equipment:OnReady():await()

local currentSlot

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

local function setProperties(slot, selected)
	local preset
	slot = container[slot]

	if selected then
		preset = selectedProperties
		selectedProperties.Size = slot.Size + UDim2.fromScale(0.2, 0.2)
	else
		preset = deselectedProperties
		deselectedProperties.Size = slot.Size - UDim2.fromScale(0.2, 0.2)
	end

	for property, value in pairs(preset) do
		slot[property] = value
	end
end

local activeTools = {}

local numslot = {
	Primary = Enum.KeyCode.One,
	Secondary = Enum.KeyCode.Two,
	BuildMode = Enum.KeyCode.Three,
	Item1 = Enum.KeyCode.Four,
	Item2 = Enum.KeyCode.Five,
	Item3 = Enum.KeyCode.Six,
	Item4 = Enum.KeyCode.Seven,
	Item5 = Enum.KeyCode.Eight,
}

local function setSlot(slot)
	if slot == "BuildMode" or slot == "Pickaxe" then
		return
	end

	local item = equipment[slot]
	slot = container[slot]

	if item then
		slot.icon.Image = item["Image"]

		if slot:FindFirstChild("amount") then
			slot.amount.Text = item["Amount"]
		end
	else
		slot.icon.Image = ""

		if slot:FindFirstChild("amount") then
			slot.amount.Text = ""
		end
	end
end

local function keytoslot(keycode)
	for slot, key in pairs(numslot) do
		if keycode == key then
			return slot
		end
	end

	return false
end

local function equipSlot(slot)
	local humanoid: Humanoid = player.Character.Humanoid

	humanoid:UnequipTools()

	if activeTools[slot] then
		local tool: Tool = activeTools[slot]

		assert(tool, "'Valid' Tool Not Found For Slot " .. slot)

		humanoid:EquipTool(tool)
	end
end

UIS.InputBegan:Connect(function(input, ignored)
	if not ignored and player.Character and (gui.Enabled or input.KeyCode == Enum.KeyCode.Three) then
		if input.KeyCode ~= Enum.KeyCode.Three then
			local slot = keytoslot(input.KeyCode)
			local humanoid: Humanoid = player.Character.Humanoid

			if slot then
				sound:Play({ "Generic", "click1" })

				if currentSlot then
					setProperties(currentSlot, false)
				end

				if slot == currentSlot then
					currentSlot = nil
					humanoid:UnequipTools()
				else
					setProperties(slot, true)
					currentSlot = slot
					equipSlot(slot)
				end
			elseif input.KeyCode == Enum.KeyCode.Backspace then
				if currentSlot then
					setProperties(currentSlot, false)
					currentSlot = nil
				end
			end
		else
			if BuildMode.Enabled then
				BuildMode:Disable()
			else
				BuildMode:Enable()
			end
		end
	end
end)

local function update(slot)
	setSlot(slot)

	if equipment[slot] then
		activeTools[slot] = backpack:WaitForChild(slot, 4)
	end
end

local slots = { "Primary", "Secondary", "Pickaxe", "Item1", "Item2", "Item3", "Item4", "Item5" }

equipment.Changed:Connect(function()
	for _, v in pairs(slots) do
		update(v)
	end
end)

backpack.ChildAdded:Connect(function(tool)
	if table.find(slots, tool.Name) then
		update(tool.Name)
	end
end)

backpack.ChildRemoved:Connect(function(tool)
	activeTools[tool.Name] = nil

	for _, slot in pairs(slots) do
		if tool.Name == slot then
			update(slot)
		end
	end
end)

for _, button in pairs(container:GetChildren()) do
	if button:IsA("TextButton") then
		button.Activated:Connect(function()
			local slot = equipment:Get()[button.Name]

			if slot then
				local comm = ClientComm:GetSignal(slot.Id)

				comm:Fire("Unequip")
			else
				sound:Play({ "Generic", "error2" })
			end
		end)
	end
end
