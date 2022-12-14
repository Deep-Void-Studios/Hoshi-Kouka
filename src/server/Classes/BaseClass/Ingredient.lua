-- Get BaseClass
local BaseClass = require(script.Parent)

-- Make class
local Ingredient = BaseClass:__MakeClass("Ingredient")

Ingredient.__Replicated = {
	Tags = true,
	ForceTags = true,
}

-- Accept children
function Ingredient:ChildAdded(object, index)
	index = index or #self + 1

	table.insert(self, index, object)

	object.Index = index
end

return Ingredient
