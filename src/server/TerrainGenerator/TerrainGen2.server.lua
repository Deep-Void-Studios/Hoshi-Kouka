local libraries = game:GetService("ServerStorage")
local generator = script.Parent
local players = game:GetService("Players")
local terrain = require(generator.Terrain)
local chunk = require(generator.Chunks)

type pos2d = {x:number, z:number}

local function deleteChunk(chunk)
	wait()
	terrain.deleteChunk(chunk)
	wait()
end

local function unloadChunks()
	local loadedChunks = chunk.loaded
	
	for i, chunk in pairs(loadedChunks) do
		deleteChunk(chunk)
	end
end

local function generate(player)
	local root = player.Character.HumanoidRootPart
	local pos = root.Position
	local chunk = chunk.findUnloaded(pos.X, pos.Z)
	
	if chunk then
		terrain.makeChunk(chunk)
	end
end

while wait() do
	for _, player in pairs(players:GetChildren()) do
		if player.Character then
			if player.Character:FindFirstChild("HumanoidRootPart") then
				generate(player)
			end
		end
	end
end
