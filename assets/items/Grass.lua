local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Grass",
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

	Model = "Grass",

	Image = "rbxassetid://10840148229"
}

return process(data)
