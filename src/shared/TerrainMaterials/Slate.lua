local RS = game:GetService("ReplicatedStorage")
local TerrainMaterial = require(RS.Classes.TerrainMaterial)

local material = TerrainMaterial:New(Enum.Material.Slate, 2, 1, {"Tools", "Pickaxe"})

return material
