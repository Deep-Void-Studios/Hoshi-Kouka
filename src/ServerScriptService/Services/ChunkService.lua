local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local ChunkService = Knit.CreateService {
	Name = "ChunkService"
}

ChunkService.Config = {
	Scale = 64,
	YScale = 256,
	RenderDistance = 4
}

ChunkService.Chunks = {}

ChunkService.Loaded = {}

ChunkService.Edits = {}

local scale = ChunkService.Config.Scale
local yScale = ChunkService.Config.YScale
local renderDistance = ChunkService.Config.RenderDistance

local chunks = ChunkService.Chunks
local loaded = ChunkService.Loaded
local edits = ChunkService.Edits

local air = Enum.Material.Air

ChunkService.Materials = {}
ChunkService.Occupancies = {}
ChunkService.Air = {}
ChunkService.Zero = {}

local mats = ChunkService.Materials
local occs = ChunkService.Occupancies
local airs = ChunkService.Air
local zero = ChunkService.Zero

for x = 1, scale do
	mats[x] = {}
	occs[x] = {}
	airs[x] = {}
	zero[x] = {}
	
	for y = 1, yScale*2+1 do
		local mats = mats[x]
		local occs = occs[x]
		local airs = airs[x]
		local zero = zero[x]
		
		mats[y] = {}
		occs[y] = {}
		airs[y] = {}
		zero[y] = {}
		
		local airs = airs[y]
		local zero = zero[y]
		
		for z = 1, scale do
			airs[z] = air
			zero[z] = 0
		end
	end
end

local function getRounded(chunk : Vector2)
	local newChunk = Vector2.new()
	
	newChunk.X = math.round(chunk.X)
	newChunk.Y = math.round(chunk.Y)
	
	return newChunk
end

function ChunkService:GetChunk(x : number, y : number, raw : boolean)
	local chunkX = x / (scale * 4) - 0.5
	local chunkY = y / (scale * 4) - 0.5
	
	if not raw then
		chunkX = math.round(chunkX)
		chunkY = math.round(chunkY)
	end
	
	return Vector2.new(chunkX, chunkY)
end

function ChunkService:ChunkExists(x : number, y : number)
	local chunks = ChunkService.Chunks
	
	if not chunks[x] then
		chunks[x] = {}
	end
	
	return chunks[x][y]
end

function ChunkService:GetLocationInChunk(x, y, z)
	local chunk : Vector3 = ChunkService:GetChunk(x, z)
	
	local chunkStart = Vector3.new(
		chunk.X * scale * 4,
		-yScale * 4 - 4,
		chunk.Y * scale * 4
	)
	
	-- Round to nearest 4
	x, y, z = math.ceil(x/4)*4, math.ceil(y/4)*4, math.ceil(z/4)*4
	
	-- Get offset from chunk start
	x = (chunkStart.X - x)/4
	y = (chunkStart.Y - y)/4
	z = (chunkStart.Z - z)/4
	
	return chunk, Vector3.new(x, y, z)
end

function ChunkService:SetChunk(x, y, state)
	local chunks = ChunkService.Chunks
	
	if not chunks[x] then
		chunks[x] = {}
	end
	
	chunks[x][y] = state
	
	if state then
		table.insert(loaded, Vector2.new(x, y))
	elseif state == nil then
		local index = table.find(loaded, Vector2.new(x, y))
		table.remove(loaded, index)
	end
end

function ChunkService:FindUnloaded(x, z)
	local center : Vector2 = ChunkService:GetChunk(x, z, true)
	local gridCenter : Vector2 = getRounded(center)
	
	local nearestChunk = nil
	local minDistance = math.huge
	
	for searchX = -renderDistance, renderDistance do
		for searchZ = -renderDistance, renderDistance do
			local chunk = Vector2.new(gridCenter.X, gridCenter.Y)
			
			local distance = (chunk - center).Magnitude
			
			if ChunkService:ChunkExists(chunk) == nil then
				if distance < minDistance then
					nearestChunk = chunk
					minDistance = distance
				end
			end
		end
	end
	
	return nearestChunk
end

return ChunkService
