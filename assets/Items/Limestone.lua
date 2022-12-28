local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Limestone",
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

	Model = "Limestone",

	Image = "rbxassetid://10840148759"
}

return process(data)
