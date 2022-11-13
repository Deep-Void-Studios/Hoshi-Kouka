local orb = workspace.Spawn["Easter Eggs"].Orb.CreationOrb
local template = Instance.new("Explosion")
template.BlastPressure = 50000
template.BlastRadius = 16
template.DestroyJointRadiusPercent = 0
template.ExplosionType = Enum.ExplosionType.NoCraters

local sounds = {
	9113701661,
	9113695203,
	9113698646,
	9113696389,
	9113695754,
	9113696177,
}

while task.wait(0.1) do
	local nearby = false

	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local char = v.Character

			if not char then
				return
			end

			local root = char.HumanoidRootPart

			if not root then
				return
			end

			if (root.Position - orb.Position).Magnitude < 24 then
				nearby = true
				break
			end
		end
	end

	if nearby then
		local displacement = Vector3.new(math.random(-8, 8), math.random(-8, 8), math.random(-8, 8))

		local pos = orb.Position + displacement

		local sound: Sound = Instance.new("Sound")
		sound.SoundId = sounds[math.random(1, 6)]
		sound.Parent = orb

		local distortion = Instance.new("DistortionSoundEffect")
		distortion.Level = 0.75
		distortion.Parent = sound

		sound:Play()

		sound.Ended:Connect(function()
			sound:Destroy()
		end)

		local explosion = template:Clone()

		explosion.Position = pos
		explosion.Parent = orb
	end
end
