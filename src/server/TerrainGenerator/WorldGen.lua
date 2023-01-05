local worldGen = {}

local SSS = game:GetService("ServerScriptService")
local terraNoise = require(SSS.PerlinNoise)
local object = require(SSS.Objects.Objects)

local noise2 = terraNoise.new

local config = require(script.Parent.TerrainConfig)

local seed = config.Seed
local scale = config.Scale
local yScale = config.YScale

local stretch = config.Stretch

local grass = Enum.Material.Grass
local dirt = Enum.Material.Ground
local water = Enum.Material.Water
local air = Enum.Material.Air
local sand = Enum.Material.Sand
local stone = Enum.Material.Rock
local slate = Enum.Material.Slate
local limestone = Enum.Material.Limestone
local basalt = Enum.Material.Basalt

-- Zones
local mountainZone = yScale * 0.7
local forestZone = yScale * 0.1
local fieldZone = yScale * 0.05
local beachZone = 0

-- Get biome from height (will be different in the future)
function worldGen:GetBiome(height)
	if height > mountainZone then
		return "Mountain"
	elseif height > forestZone then
		return "Forest"
	elseif height > fieldZone then
		return "Field"
	elseif height > beachZone then
		return "Beach"
	else
		return "Ocean"
	end
end

-- Get material for height.
worldGen.getMaterial = function(cy, height)
	cy += yScale
	height += yScale

	if cy < height then
		if cy < height * 0.1 then
			return basalt
		elseif cy < height * 0.4 then
			return limestone
		elseif cy < height * 0.7 then
			return slate
		elseif cy < height * 0.95 then
			return stone
		elseif cy < height * 0.99 then
			local biome = worldGen:GetBiome(height - yScale)

			if biome == "Ocean" or biome == "Beach" then
				return sand
			elseif biome == "Field" or biome == "Forest" then
				return dirt
			else
				return stone
			end
		else
			local biome = worldGen:GetBiome(height - yScale)

			if biome == "Ocean" or biome == "Beach" then
				return sand
			elseif biome == "Field" or biome == "Forest" then
				return grass
			else
				return stone
			end
		end
	else
		if cy > yScale then
			return air
		else
			return water
		end
	end
end

-- Generate height table
worldGen.genHeightTable = function(htab, x, z)
	for cx = 1, scale do
		local htabx = htab[cx]
		for cz = 1, scale do
			local x2 = (x * 64 + cx)
			local z2 = (z * 64 + cz)
			htabx[cz] = noise2({ x2, z2, seed * 100 }, stretch, 8) * yScale
		end
	end
end

function worldGen:MakeDecor(obj, pos)
	local rotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
	local cframe = pos * rotation

	object.placeNC(obj, cframe)
end

local function weightedRandom(chancetable)
	local total = 0

	local sums = {}

	for _, v in pairs(chancetable) do
		table.insert(sums, { v[1], total })

		total += v[2]
	end

	local selected = math.random(0, total)

	for i = #sums, 1, -1 do
		local current = sums[i]

		if selected >= current[2] then
			return current[1]
		end
	end

	print(sums, selected)
	error("No object was able to be selected.")
end

local function decorChance(chance, chancetable)
	if math.random(0, chance) == 0 then
		local ty = weightedRandom(chancetable)

		return object.randomDecoration({ ty })
	end
end

local function getDecor(height, x, z, cx, cy, cz)
	local biome = worldGen:GetBiome(height)
	local decor

	if biome == "Forest" then
		decor = decorChance(60, {
			{ "SmallPlant", 60 },
			{ "Plant", 60 },
			{ "BigPlant", 5 },
			{ "Tree", 60 },
			{ "BigTree", 10 },
			{ "SmallTree", 20 },
			{ "WeepingTree", 20 },
			{ "Rock", 30 },
		})
	elseif biome == "Field" then
		decor = decorChance(480, {
			{ "SmallPlant", 60 },
			{ "Plant", 60 },
			{ "BigPlant", 10 },
			{ "Rock", 10 },
			{ "Tree", 5 },
			{ "WeepingTree", 2 },
		})
	elseif biome == "Beach" then
		decor = decorChance(960, {
			{ "BeachTree", 100 },
		})
	end

	if decor then
		return { decor, worldGen:GetWorldSpace(x, z, cx, cy, cz) }
	end
end

function worldGen:GetWorldSpace(x, z, cx, cy, cz)
	return CFrame.new((x * 64 + cx) * 4 - 2, cy * 4, (z * 64 + cz) * 4 - 2)
end

worldGen.getOccupancy = function(cy, height, _, x, z, cx, cz)
	-- Check if chunk y is under the height level.
	if cy < math.floor(height) then
		-- Voxel is underground; full voxel.
		return 1
	elseif cy < height then
		-- Voxel is on the surface; calculate occupancy and check for decoration.
		return height - cy, getDecor(height, x, z, cx, cy, cz)
	elseif cy <= 0 then
		-- Voxel is above height but under sea level.
		return 1
	else
		-- Voxel is above the surface; air voxel.
		return 0
	end
end

return worldGen
