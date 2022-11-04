local chunk = {}

local config = require(script.Parent.TerrainConfig)

local scale = config.Scale
local yScale = config.YScale
local rDist = config.RenderDistance

type pos2d = { x: number, z: number }

chunk.table = {}

chunk.loaded = {}

local air = Enum.Material.Air

chunk.mats = {}
chunk.occs = {}
chunk.air = {}
chunk.zero = {}

for x = 1, scale do
	chunk.mats[x] = {}
	chunk.occs[x] = {}
	chunk.air[x] = {}
	chunk.zero[x] = {}
	for y = 1, yScale * 2 + 1 do
		chunk.mats[x][y] = {}
		chunk.occs[x][y] = {}
		chunk.air[x][y] = {}
		chunk.zero[x][y] = {}
		for z = 1, scale do
			chunk.air[x][y][z] = air
			chunk.zero[x][y][z] = 0
		end
	end
end

chunk.makePos = function(x, z)
	local pos: pos2d = { x = x, z = z }
	return pos
end

local function getRounded(c)
	local newChunk: pos2d = { x = 0, z = 0 }

	newChunk.x = math.round(c.x)
	newChunk.z = math.round(c.z)

	return newChunk
end

chunk.getChunk = function(x, z, raw)
	local gx = x / (scale * 4) - 0.5
	local gz = z / (scale * 4) - 0.5

	if not raw then
		gx = math.round(gx)
		gz = math.round(gz)
	end

	local pos: pos2d = { x = gx, z = gz }

	return pos
end

chunk.exists = function(pos: pos2d)
	if not chunk.table[pos.x] then
		chunk.table[pos.x] = {}
	end

	return chunk.table[pos.x][pos.z]
end

chunk.setChunk = function(c, state)
	local cx = c.x
	local cz = c.z

	if not chunk.table[cx] then
		chunk.table[cx] = {}
	end

	chunk.table[cx][cz] = state

	if state == true then
		table.insert(chunk.loaded, c)
	elseif state == nil then
		local index = table.find(chunk.loaded, c)
		table.remove(chunk.loaded, index)
	end
end

chunk.findUnloaded = function(x, z)
	local center = chunk.getChunk(x, z, true)
	local gridCenter = getRounded(center)

	local nearestChunk = nil
	local dist = nil

	-- Get nearest chunk
	for sx = -rDist, rDist do
		for sz = -rDist, rDist do
			local s: pos2d = {
				x = gridCenter.x + sx,
				z = gridCenter.z + sz,
			}

			local sv = Vector2.new(s.x, s.z)
			local cv = Vector2.new(center.x, center.z)
			local chunkDist = (sv - cv).Magnitude

			-- Check if chunk is already loaded
			if chunk.exists(s) == nil then
				if chunkDist <= rDist then
					if dist then
						if chunkDist < dist then
							nearestChunk = s
							dist = chunkDist
						end
					else
						nearestChunk = s
						dist = chunkDist
					end
				end
			end
		end
	end

	if nearestChunk then
		return nearestChunk
	else
		return nil
	end
end

return chunk
