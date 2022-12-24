local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local button = workspace.Spawn.ResetData.DataResetter.button

button.MouseClick:Connect(function(player: Player)
	DataManager:Reset(player)
end)
