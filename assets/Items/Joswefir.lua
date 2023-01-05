local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Joswefir",
	Description = "",
	Type = "Food",
	Amount = 1,

	Properties = {
		Volume = 0,
		Weight = 0,
		FoodVolume = 10,
		Calories = 1000,
	},

	Actions = {
		Eat = true,
		Drop = true,
		DropAll = true,
	},

	Model = "Joswefir",

	Image = "rbxassetid://8479248871",
}

return process(data)
