local players = game:GetService("Players")
local bannedPlayers = require(script.BannedPlayers)

players.PlayerAdded:Connect(function(player)
	if bannedPlayers[player.UserId] then
		player:Kick("You have been banned from this experience.")
	end
end)
