local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Ground",
	Description = "",
	Type = "TerrainMaterial",
	Amount = 1,

	Properties = {
		Volume = 5,
		Weight = 20
	},

	Actions = {
		Drop = true,
		DropAll = true
	},

	Model = "Ground",

	Image = "rbxassetid://10840148100"
}

return process(data)
