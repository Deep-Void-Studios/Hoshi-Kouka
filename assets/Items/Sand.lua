local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Sand",
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

	Model = "Sand",

	Image = "rbxassetid://10840148330"
}

return process(data)
