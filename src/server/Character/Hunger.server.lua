local Players = game:GetService("Players")
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")

Players.PlayerAdded:Connect(function(player)
	while task.wait(1) do
		if player.Character then
			local data = DataManager:Get(player)
			local status = data.Status

			status:DrainVital("Hunger", 0.03)
		end
	end
end)
