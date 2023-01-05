local process = require(script.Parent.Parent:WaitForChild("__DataProcessor"))

local ingredients = {
	{ "Ingot", 3, { "Iron" }, forceTags = true },
	{ "Rod", 1, { "Wood" }, forceTags = true },
}

local results = {
	{ "Test Axe", 1 },
}

return process(ingredients, results)
