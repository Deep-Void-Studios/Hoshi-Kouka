local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():andThen(function()
	local Players = game:GetService("Players")
	local AchievementService = Knit.GetService("AchievementService")

	Players.PlayerAdded:Connect(function(player)
		AchievementService:Award(player, 2126308538)
	end)
end)
