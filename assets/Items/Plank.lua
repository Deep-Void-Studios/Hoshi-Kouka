local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Plank",
	Description = "",
	Type = "Material",
	Amount = 1,

	Properties = {
		Volume = 8,
		Weight = 16,
	},

	Actions = {
		Drop = true,
		DropAll = true,
	},

	Model = "Plank",

	Image = "rbxassetid://",
}

return process(data)
