local RS = game:GetService("ReplicatedStorage")
local TerrainMaterial = require(RS.Classes.TerrainMaterial)

local material = TerrainMaterial:New(Enum.Material.Basalt, 16, 2, {"Tools", "Pickaxe"})

return material
