local RS = game:GetService("ReplicatedStorage")
local TerrainMaterial = require(RS.Classes.TerrainMaterial)

local material = TerrainMaterial:New(Enum.Material.Rock, 1, 1, {"Tools", "Pickaxe"})

return material
