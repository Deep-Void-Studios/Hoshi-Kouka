local RS = game:GetService("ReplicatedStorage")
local TerrainMaterial = require(RS.Classes.TerrainMaterial)

local material = TerrainMaterial:New(Enum.Material.Limestone, 4, 1, {"Tools", "Pickaxe"})

return material
