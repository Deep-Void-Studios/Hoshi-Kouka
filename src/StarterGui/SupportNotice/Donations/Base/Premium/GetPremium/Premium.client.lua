local button = script.Parent
local market = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

button.Activated:Connect(function()
	market:PromptPremiumPurchase(player)
end)
