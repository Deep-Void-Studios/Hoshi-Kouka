local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Rod",
	Description = "",
	Type = "Tool Handle",
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

	Model = "Rod",

	Image = "rbxassetid://",
}

return process(data)
