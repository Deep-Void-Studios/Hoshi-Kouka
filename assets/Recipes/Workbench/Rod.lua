local process = require(script.Parent.Parent:WaitForChild("__DataProcessor"))

local ingredients = {
	{ "name", 1 },
	{ "otherName", 3 },
}

local results = {
	{ "resultName", 4 },
	{ "you probably won't need multiple results but just in case", 1 },
}

return process(ingredients, results)
