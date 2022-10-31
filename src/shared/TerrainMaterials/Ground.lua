local RS = game:GetService("ReplicatedStorage")
local TerrainMaterial = require(RS.Classes.TerrainMaterial)

local material = TerrainMaterial:New(Enum.Material.Ground, 0.3, 0, {"Tools", "Shovel"})

return material
