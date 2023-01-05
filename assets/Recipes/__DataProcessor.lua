local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local Recipe = Knit.GetService("Recipe")
local ItemService = Knit.GetService("ItemService")

local function process(ingredients, results)
  local recipe = Recipe:New()

  for i, v in pairs(ingredients) do
    local name = v[1]
    local amount = v[2]

    local item = ItemService:GetItem(name):Clone()

    item:SetParent(recipe.Ingredients)
  end

  for i, v in pairs(results) do
    local name = v[1]
    local amount = v[2]

    local item = ItemService:GetItem(name):Clone()

    item:SetParent(recipe.Results)
  end
end

return process