local button = script.Parent
local market = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

local productID = 1194049753

button.Activated:Connect(function()
	market:PromptProductPurchase(player, productID)
end)
