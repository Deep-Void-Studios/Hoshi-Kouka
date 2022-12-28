--local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
--local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Recipe = BaseClass:__MakeClass("Recipe")

Recipe.__Replicated = {
	Ingredients = true,
	Results = true,
}

Recipe.__Defaults = {}

return Recipe
