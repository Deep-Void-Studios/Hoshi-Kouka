local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Rock",
	Description = "",
	Type = "TerrainMaterial",
	Amount = 1,

	Properties = {
		Volume = 5,
		Weight = 40
	},

	Actions = {
		Drop = true,
		DropAll = true
	},

	Model = "Rock",

	Image = "rbxassetid://10840147943"
}

return process(data)
