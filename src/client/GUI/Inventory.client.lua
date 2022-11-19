local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

local RS = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local template = RS.ClientAssets.GUI.InventoryButton
local base = player.PlayerGui.Inventory.Cover.Base
local gui = base.Container

local menu = Knit.GetController("ContextMenu")
local itemset = Knit.GetController("Context/Item")

local DataManager = Knit.GetService("DataManager")
local _, dataId = DataManager:Get(player):await()
local data = ClientComm:GetProperty(dataId)

data:OnReady():await()

print(data:Get())

local inventory = ClientComm:GetProperty(data:Get().Inventory)

local function truncate(number)
	local num = tostring(number)
	local place = string.find(num, ".")

	if place then
		return string.sub(num, 1, place + 2)
	else
		return num
	end
end

local function addItem(item, index)
	local button = template:Clone()

	button.Name = index
	button.Title.Text = item.Name
	button.Amount.Text = truncate(item.Amount)
	button.Icon.Image = item.Image
	button.Parent = gui

	button.Activated:Connect(function()
		menu:Open(item.Actions, itemset, 0, {
			PLAYER = item.Player,
		})
	end)
end

local function updateItem(index)
	local button = gui:FindFirstChild(index)
	local itemId = inventory:Get()[index]

	if not itemId then
		return
	end

	local item = ClientComm:GetProperty(itemId)

	if not item:IsReady() then
		warn(itemId .. " not ready.")
		item:OnReady():await()
	end

	print("Updating item " .. index)

	if button then
		print("button")
		if item then
			print("item")
			if item.Amount > 0 then
				print("amount > 0")
				button.Name = index
				button.Title.Text = item.Name
				button.Amount.Text = truncate(item.Amount)
				button.Icon.Image = item.Image
			else
				print("amount <= 0")
				button:Destroy()
			end
		else
			print("no item")
			button:Destroy()
		end
	else
		print("no button")
		if item then
			print("item")
			addItem(item, index)
		else
			print("no item")
		end
	end
end

inventory.Changed:Connect(function()
	print("Received change signal.")

	print(inventory)

	for i = 1, #inventory:Get() + 1 do
		updateItem(i)
	end
end)

for i = 1, #inventory:Get() + 1 do
	updateItem(i)
end
