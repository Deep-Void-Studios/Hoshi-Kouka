local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Ore",
	Description = "",
	Type = "Material",
	Amount = 1,
    
    Tags = {
        Modular = true,
    },

	Properties = {
		Volume = 8,
		Weight = 16,
	},

	Actions = {
		Drop = true,
		DropAll = true,
	},

	Model = "Ingot",

	Image = "rbxassetid://",
}

return process(data)
