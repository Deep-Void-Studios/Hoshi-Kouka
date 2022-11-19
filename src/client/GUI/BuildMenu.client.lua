local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local _, data = DataManager:Get(game:GetService("Players").LocalPlayer):await()
local inventory = data.Inventory

local RS = game:GetService("ReplicatedStorage")
local BuildMode = require(RS.Libraries.BuildMode)
local gui = script.Parent
local container = gui.Container
local template = script.Template

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

update()
