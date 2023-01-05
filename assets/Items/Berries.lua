local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Berries",
	Description = "",
	Type = "Food",
	Amount = 1,

	Properties = {
		Volume = 8,
		Weight = 16,
	},

	Actions = {
		Drop = true,
		Eat = true,
		DropAll = true,
	},

	Model = "Berries",

	Image = "rbxassetid://",
}

return process(data)
