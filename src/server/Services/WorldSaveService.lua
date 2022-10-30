local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local WorldSaveService = Knit.CreateService {
	Name = "WorldSaveService"
}

local ToSave = {}

local function SaveChunk(x, z)
	local DatabaseService = Knit.GetService("DatabaseService")
	local ChunkService = Knit.GetService("ChunkService")
	
	DatabaseService:Set(x.." "..z, ChunkService.Edits[x][z])
end

function WorldSaveService:SetModified(x, y, z, material, occupancy)
	local ChunkService = Knit.GetService("ChunkService")
	
	local chunk, offset = ChunkService:GetLocationInChunk(x, y, z)
	
	ChunkService.Edits[chunk.X][chunk.Y][offset.X][offset.Y][offset.Z] = {Material = material, Occupancy = occupancy}
	
	
end

function WorldSaveService:LoadChunk(x, z)
	local DatabaseService = Knit.GetService("DatabaseService")

	DatabaseService:Get(x.." "..z)
end

return WorldSaveService
