local terrain = {}

local terrainService = game.Workspace.Terrain

local config = require(script.Parent.TerrainConfig)

local generator = script.Parent
local chunkMod = generator.Chunks
local chunk = require(chunkMod)
local worldGen = require(generator.WorldGen)
local mats = chunk.mats
local occs = chunk.occs
local air = chunk.air
local zero = chunk.zero

local seed = config.Seed
local yield = config.Yield
local scale = config.Scale
local yScale = config.YScale

math.randomseed(seed)

type pos2d = { x: number, z: number }

-- Create a 2D height table which is scale x scale in size
local htab = {}
for cx = 1, scale do
	htab[cx] = {}
end

local function genRegion(x, z)
	-- Create region to fill
	local rStart = Vector3.new(x * scale * 4, -yScale * 4 - 4, z * scale * 4)

	local rEnd = Vector3.new((x + 1) * scale * 4, yScale * 4, (z + 1) * scale * 4)

	return Region3.new(rStart, rEnd)
end

terrain.deleteChunk = function(pos: pos2d)
	-- Get region containing chunk
	local region = genRegion(pos.x, pos.z)

	-- Delete chunk
	terrainService:WriteVoxels(region, 4, air, zero)

	-- Set chunk as unloaded
	chunk.setChunk(pos, nil)
end

-- Generate a chunk at given position in chunk coordinates.
terrain.makeChunk = function(pos: pos2d)
	-- Set x and z
	local x = pos.x
	local z = pos.z

	-- Create table of heights for each column
	worldGen.genHeightTable(htab, x, z)

	-- Tell scripts the chunk is currently generating.
	chunk.setChunk(pos, false)

	-- Object placement table
	local toPlace = {}

	for cx = 1, scale do
		-- Pause terrain generator every 1/yield times to reduce lag.
		if cx % yield == 0 then
			task.wait()
		end

		for cz = 1, scale do
			-- Get Height
			local height = htab[cx][cz]

			local mcx = mats[cx]
			local ocx = occs[cx]

			for cy = -yScale, yScale do
				-- Generate material
				local mat = worldGen.getMaterial(cy, height)
				local tY = cy + yScale + 1

				mcx[tY][cz] = mat

				-- Generate occupancy
				local val, decor = worldGen.getOccupancy(cy, height, tY, x, z, cx, cz)

				ocx[tY][cz] = val

				if decor then
					table.insert(toPlace, decor)
				end
			end
		end
	end

	local region = genRegion(x, z)

	-- Create terrain
	terrainService:WriteVoxels(region, 4, mats, occs)

	-- Generate terrain decorations
	for _, v in pairs(toPlace) do
		worldGen:MakeDecor(v[1], v[2])
	end

	-- Tell scripts that the chunk is generated.
	chunk.setChunk(pos, true)
end

return terrain
