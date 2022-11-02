local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Basalt",
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

	Model = "Basalt",

	Image = "rbxassetid://10840148644"
}

return process(data)
