local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():await()

local PromptService = game:GetService("ProximityPromptService")
local SSS = game:GetService("ServerScriptService")
local ItemService = Knit.GetService("ItemService")
local DataManager = Knit.GetService("DataManager")

PromptService.PromptTriggered:Connect(function(prompt, player)
	if prompt.Name == "itemPrompt" then
		local inventory = DataManager:Get(player).Inventory
		
		local item = prompt.Parent.Parent
		local name = item.Name

		local itemData = require(item.ItemData)
		
		if inventory:CanHold(itemData) then
			ItemService:Remove(item)
			itemData:SetParent(inventory)
		end
	end
end)
