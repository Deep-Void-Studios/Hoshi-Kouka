local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Deluxe Torch",
	Description = "A good light source.",
	Type = "Tool",
	Amount = 1,

	Properties = {
		Volume = 4,
		Weight = 1,
	},

	Actions = {
		Drop = true,
		DropAll = true
	},

	Model = "Deluxe Torch",

	Image = "rbxassetid://10798019314"
}

return process(data)
