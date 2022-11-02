local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local Character = Knit.GetService("Character")
local DataManager = Knit.GetService("DataManager")

local button = workspace.Spawn.Props.DataResetter.button

button.MouseClick:Connect(function(player: Player)
	local data = DataManager:Get(player)

	for i, v in pairs(Character:New()) do
		data[i] = v
	end

	player:Kick("Deleting Data...")
end)
