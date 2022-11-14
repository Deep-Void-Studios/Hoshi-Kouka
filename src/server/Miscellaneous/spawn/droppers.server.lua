local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local ItemService = Knit.GetService("ItemService")
local droppers = workspace.Spawn.Droppers
local spawnSound = game:GetService("SoundService").SFX.Miscellaneous.spawn

for _, obj in pairs(droppers:GetDescendants()) do
	print("searching")
	if obj:GetAttribute("Item") then
		print("found")
		local dispenser = obj
		local spawner = dispenser.Spawner
		local sound = spawnSound:Clone()
		sound.Parent = spawner

		local item = dispenser:GetAttribute("Item")
		local cooldown = dispenser:GetAttribute("Cooldown")
		local max = dispenser:GetAttribute("MaxItems")
		item = ItemService:GetItem(item)

		local items = {}

		local function checkItems()
			for i, v in pairs(items) do
				if not v.Parent then
					table.remove(items, i)
				end
			end
		end

		while task.wait(cooldown) do
			checkItems()
			if item and #items < max then
				sound:Play()
				local new: Model = ItemService:Spawn(item, spawner.CFrame)
				table.insert(items, new)
			end
		end
	end
end
