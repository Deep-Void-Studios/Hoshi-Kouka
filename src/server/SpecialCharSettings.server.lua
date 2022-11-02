-- feel free to request some special sizes for your character here if you want,
-- it's just an extra feature I added for fun. -aimi

local players = game.Players
local optionSets = {
	[1407872572] = {
		HeadScale = 0.8,
		DepthScale = 1.05,
		WidthScale = 1.1,
		HeightScale = 0.5,
	},
	[7193255111] = {
		HeadScale = 0.8,
		DepthScale = 0.8,
		WidthScale = 0.8,
		HeightScale = 0.5,
	},
}

players.PlayerAdded:Connect(function(player)
	if optionSets[player.UserId] then
		player.CharacterAdded:Connect(function(char)
			local options = optionSets[player.UserId]
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
