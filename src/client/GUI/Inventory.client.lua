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
local inventory = ClientComm:GetProperty(data:Get().Inventory)
inventory:OnReady():await()

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
		local id = inventory:Get()[index]

		if not id then
			warn("Item not found.")
			return
		end

		local currentItem = ClientComm:GetProperty(id)

		currentItem:OnReady():await()

		currentItem = currentItem:Get()

		menu:Open(currentItem.Actions, itemset, 0, {
			SUBJECT = currentItem,
			PLAYER = player,
		})
	end)
end

local function updateItem(index)
	local itemId = inventory:Get()[index]

	if not itemId then
		local button = gui:FindFirstChild(index)

		if button then
			button:Destroy()
		end
		return
	end

	local item = ClientComm:GetProperty(itemId)

	if not item:IsReady() then
		item:OnReady():await()
	end

	item = item:Get()

	local button = gui:FindFirstChild(index)

	if button then
		if item then
			if item.Amount > 0 then
				button.Name = index
				button.Title.Text = item.Name
				button.Amount.Text = truncate(item.Amount)
				button.Icon.Image = item.Image
			else
				button:Destroy()
			end
		else
			button:Destroy()
		end
	else
		if item then
			addItem(item, index)
		end
	end
end

local current = 0

inventory.Changed:Connect(function()
	current += 1

	local processId = current

	for i = 1, #inventory:Get() + 1 do
		if processId ~= current then
			-- terminate process to save processing power and prevent glitches
			break
		end

		updateItem(i)
	end
end)

for i = 1, #inventory:Get() + 1 do
	updateItem(i)
end
