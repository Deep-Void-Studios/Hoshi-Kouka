local process = require(script.Parent.Parent:WaitForChild("__DataProcessor"))

local ingredients = {
	{ "Ore", 1 },
	{ "Coal", 3 },
}

local function results(usedIngredients, ItemService)
	local material = usedIngredients[1].Tags.Material

	local result = ItemService:GetItem("Ingot")

	result.Tags.Material = material

	return result
end

return process(ingredients, results)
