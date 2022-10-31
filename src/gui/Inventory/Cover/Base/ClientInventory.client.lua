local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():await()

local RS = game:GetService("ReplicatedStorage")
local hoshiutils = require(RS.Libraries.HoshiUtils)
local pathfind = hoshiutils.Pathfind
local copy = hoshiutils.DeepCopy
local player = game.Players.LocalPlayer
local menu = Knit.GetController("ContextMenu")
local itemset = Knit.GetController("Context/Item")
local base = script.Parent
local gui = base.Container
local template = script.Button
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")
local DataManager = Knit.GetService("DataManager")
local _, dataId = DataManager:Get(player):await()
local data = ClientComm:GetProperty(dataId)
local inventory = ClientComm:GetProperty(data.Inventory.Id)

local function truncate(number)
	local num = tostring(number)
	local place = string.find(num, ".")

	if place then
		return string.sub(num, 1, place+2)
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
			PLAYER = item.Player
		})
	end)
end  

local function updateItem(index)
	local button = gui:FindFirstChild(index)
	local item = inventory[index]
	
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
			addItem(inventory[index], index)
		end
	end
end

inventory.Updated:Connect(function()
	
end)

for i, v in ipairs(inventory) do
	updateItem(i)
end