local players = game.Players
local options = {
	[1407872572] = {
		-- Aimi
		HeadScale = 0.8,
		DepthScale = 1.05,
		WidthScale = 1.1,
		HeightScale = 0.5
	},
	[00] = {
		-- Sophie
		WidthScale = 10,
		DepthScale = 20,
		HeightScale = 5,
		HeadScale = 10
	},
	[7193255111] = {
		HeadScale = 0.8,
		DepthScale = 0.8,
		WidthScale = 0.8,
		HeightScale = 0.5
	}
}

local function findId(id)
	for i, _ in pairs(options) do
		if i == id then
			return true
		end
	end
	return false
end

players.PlayerAdded:Connect(function(player)
	if findId(player.UserId) then
		player.CharacterAdded:Connect(function(char)
			local options = options[player.UserId]
			local humanoid = char:WaitForChild("Humanoid")
			local desc = humanoid:WaitForChild("HumanoidDescription")
			
			for i, v in pairs(options) do
				desc[i] = v
			end
			
			humanoid.HeadScale.Value = options.HeadScale
			humanoid.BodyDepthScale.Value = options.DepthScale
			humanoid.BodyHeightScale.Value = options.HeightScale
			humanoid.BodyWidthScale.Value = options.WidthScale
			
			humanoid.WalkSpeed = humanoid.WalkSpeed * options.HeightScale
			humanoid.JumpHeight = humanoid.JumpHeight * options.HeightScale
		end)
	end
end)
