local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Joswefir",
	Description = "",
	Type = "Food",
	Amount = 1,

	Properties = {
		Volume = 0,
		Weight = 0,
		FoodVolume = 100,
		Calories = 100,
	},

	Actions = {
		Drop = true,
		DropAll = true,
	},

	Model = "Joswefir",

	Image = "rbxassetid://8479248871",
}

return process(data)
