-- Get Knit Framework
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
--local Signal = require(Knit.Util.Signal)

-- Get BaseClass
local BaseClass = require(script.Parent)

-- Make class
local Recipe = BaseClass:__MakeClass("Recipe")

-- Which values will be sent to the client?
-- Note: Objects are always replicated.
Recipe.__Replicated = {
	Delay = true,
	Background = true,
}

-- Run on Knit Start
function Recipe:KnitStart()
	-- Get ItemGroup class
	local ItemGroup = Knit.GetService("ItemGroup")

	-- Define Recipe defaults
	Recipe.__Defaults = {
		Ingredients = ItemGroup:New(), -- The ingredients required to craft an item.
		Results = ItemGroup:New(), -- The results of crafting this recipe.
		Delay = 0.5, -- How long does the player have to wait?
		Background = false, -- Can the player leave the workstation while it's crafting? (ex: furnace smelting iron)
	}
end

-- Craft the recipe with the input inventory and sent to the output inventory (or item group)
-- input - Which inventory will the input items be taken from?
-- output - Which inventory or item group will the output items be sent to?
function Recipe:Craft(input, output)
	local Ingredients = self.Ingredients -- Get the item's ingredients

	for _, ingredient in pairs(Ingredients:GetItems()) do -- Loop through ingredients
		local checkIngredient = false
		for _, item in pairs(input:GetItems()) do -- Loop through player inventory
			if item.Name == ingredient.Name then -- Check if the item's name in inventory is the same as ingredient's name
				checkIngredient = true
				if item.Amount == ingredient.Amount then -- Check if item's amount is enough to craft
					self:Clone():Transfer(output)
					item:AddAmount(-ingredient.Amount)
				else
					warn('Not enough ingredients!')
					return false 
				end
			end
		end
		if not checkIngredient then
			warn('Player does not have this ingredient!')
			return false
		end
	end

	return true
end

return Recipe
