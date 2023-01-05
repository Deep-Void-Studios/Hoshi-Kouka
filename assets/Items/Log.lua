local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Log",
	Description = "",
	Type = "Material",
	Amount = 1,
    
    Tags = {
        Modular = true,
    },
	
	Properties = {
		Volume = 10,
		Weight = 25,
	},

	Actions = {
		Drop = true,
		DropAll = true,
	},

	Model = "Log",

	Image = "rbxassetid://",
}

return process(data)
