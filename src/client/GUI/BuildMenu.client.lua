local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local _, dataId = DataManager:Get(game:GetService("Players").LocalPlayer):await()
local data = ClientComm:GetProperty(dataId)
data:OnReady():await()
local inventory = ClientComm:GetProperty(data:Get().Inventory)
inventory:OnReady():await()

local RS = game:GetService("ReplicatedStorage")
local BuildMode = require(RS.Libraries.BuildMode)
local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("BuildMode"):WaitForChild("Materials")
local container = gui:WaitForChild("Container")
local template = RS:WaitForChild("ClientAssets"):WaitForChild("GUI"):WaitForChild("MaterialButton")

local activeButton

local function makeButton(item, index)
	local button = template:Clone()
	local material = Enum.Material[item.Name]
	button.Name = item.Name
	button.LayoutOrder = index
	button.Image = item.Image
	button.Text.Text = item.Name
	button.Amount.Text = item.Amount

	button.Activated:Connect(function()
		if activeButton then
			activeButton.Text.FontFace.Bold = false
			activeButton.Text.TextColor3 = Color3.new(1, 1, 1)
		end

		activeButton = button

		button.Text.FontFace.Bold = true
		button.Text.TextColor3 = Color3.new(1, 1)

		BuildMode.SelectedMaterial = material
	end)
end

local function update()
	for _, obj in pairs(container:GetChildren()) do
		if not obj:IsA("UIGridLayout") then
			obj:Destroy()
		end
	end

	for i, item in ipairs(inventory) do
		if item.Type == "TerrainMaterial" then
			makeButton(item, i)
		end
	end
end

inventory.Changed:Connect(update)

update()
