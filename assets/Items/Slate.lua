local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Slate",
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

	Model = "Slate",

	Image = "rbxassetid://10840148501"
}

return process(data)
