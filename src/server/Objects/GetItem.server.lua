local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local PromptService = game:GetService("ProximityPromptService")
local ItemService = Knit.GetService("ItemService")
local DataManager = Knit.GetService("DataManager")
local Notify = Knit.GetService("NotificationService")

PromptService.PromptTriggered:Connect(function(prompt, player)
	if prompt.Name == "itemPrompt" then
		local inventory = DataManager:Get(player).Inventory

		local model = prompt.Parent.Parent

		local objectInfo = require(model.ObjectInfo)
		local item = objectInfo.Item

		local canHold, err = inventory:CanHold(item)

		if canHold then
			ItemService:Remove(model)

			item:SetParent(inventory)
		else
			Notify:Error("Action Failed", err, player)
		end
	end
end)
