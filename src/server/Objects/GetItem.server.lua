local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local PromptService = game:GetService("ProximityPromptService")
local ItemService = Knit.GetService("ItemService")
local DataManager = Knit.GetService("DataManager")

PromptService.PromptTriggered:Connect(function(prompt, player)
	if prompt.Name == "itemPrompt" then
		local inventory = DataManager:Get(player).Inventory

		local item = prompt.Parent.Parent

		local itemData = require(item.ItemData)

		if inventory:CanHold(itemData) then
			ItemService:Remove(item)
			itemData:SetParent(inventory)
		end
	end
end)
