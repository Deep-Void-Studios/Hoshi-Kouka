--[[ local DatabaseService = Knit.GetService("DatabaseService")

local player = game.Players:WaitForChild("AimiAmano")
while not player.Character do
	wait()
end
local root = player.Character:WaitForChild("HumanoidRootPart")

wait(4)

local chunk = Chunks.getChunk(root.Position.X, root.Position.Z)

local region = genRegion(chunk.x, chunk.z)

local part = Instance.new("Part")
part.Material = Enum.Material.ForceField
part.Anchored = true
part.CFrame = region.CFrame
part.Size = region.Size

local materials, occupancy = workspace.Terrain:ReadVoxels(region, 4)
local https = game:GetService("HttpService")
--local compress = require(game.ServerStorage.utility.compression).compress

--for x, v in ipairs(materials) do
--	for y, v in ipairs(v) do
--		for z, m in ipairs(v) do
--			v[z] = encodeMaterial(m)
--		end
--	end

--	materials[x] = compress(https:JSONEncode(v))

--	print(x.."/"..#materials)
--	task.wait()
--end

local data: any = https:JSONEncode({ Materials = materials, Occupancy = occupancy })
print(string.len(data))
--data = compress(data)
print(string.len(data))

DatabaseService:Set(chunk.x .. " " .. chunk.z, data)

print(string.len(DatabaseService:Get("0 0")))
 ]]
