local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():await()

local dispenser = script.Parent
local spawner = dispenser.Spawner
local sound = script.SpawnSound
sound.Parent = spawner

local item = dispenser:GetAttribute("Item")
local cooldown = dispenser:GetAttribute("Cooldown")
local max = dispenser:GetAttribute("MaxItems")

local libraries = game:GetService("ServerScriptService")
local ItemService = Knit.GetService("ItemService")
item = ItemService:GetItem(item)

local items = {}

local function checkItems()
	for i, v in pairs(items) do
		if not v.Parent then
			table.remove(items, i)
		end
	end
end

while wait(cooldown) do
	checkItems()
	if item and #items < max then
		sound:Play()
		local new:Model = ItemService:Spawn(item, spawner.CFrame)
		table.insert(items, new)
	end
end

