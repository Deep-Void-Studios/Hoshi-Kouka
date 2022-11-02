local players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local chunks = require(SSS.TerrainGenerator.Chunks)

local locations = {}

while wait(0.2) do
	for _, player:Player in pairs(players:GetPlayers()) do
		local found
		local char:Model
		if player.Character then
			if player.Character:FindFirstChild("HumanoidRootPart") then
				found = true
				char = player.Character
			end
		end
		if found then
			local wPos = char:GetPivot()
			local nearestChunk = chunks.getChunk(wPos.X, wPos.Z)
			local inLoaded = chunks.exists(nearestChunk)
			
			if inLoaded then
				locations[player.Name] = wPos
			else
				if locations[player.Name] then
					char:PivotTo(locations[player.Name])
				end
			end
		else
			locations[player.Name] = nil
		end
	end
end
