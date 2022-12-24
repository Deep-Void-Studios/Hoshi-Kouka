local contentProvider = game:GetService("ContentProvider")
local orb = workspace.Spawn.Other.Orb.CreationOrb
local template = Instance.new("Explosion")
template.BlastPressure = 30000
template.BlastRadius = 12
template.DestroyJointRadiusPercent = 0
template.ExplosionType = Enum.ExplosionType.NoCraters

local sounds = game:GetService("SoundService").SFX.Explosion:GetChildren()

contentProvider:PreloadAsync(sounds)

while task.wait(0.2) do
	local nearby = false

	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local char = v.Character

			if not char then
				return
			end

			local root = char:FindFirstChild("HumanoidRootPart")

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

		local sound: Sound = sounds[math.random(1, 8)]:Clone()
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
