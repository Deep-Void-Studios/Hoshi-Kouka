local template = script.explosion
local orb = workspace.Spawn.CreationOrb

while task.wait(0.1) do
	local nearby = false
	
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local char = v.Character
			local root = char.HumanoidRootPart
			
			if (root.Position - orb.Position).Magnitude < 24 then
				nearby = true
				break
			end
		end
	end
	
	if nearby then
		local displacement = Vector3.new(
			math.random(-8, 8),
			math.random(-8, 8),
			math.random(-8, 8)
		)
		
		local pos = orb.Position + displacement
		
		local sound : Sound = script["sound"..math.random(1,6)]:Clone()
		sound.Parent = orb
		sound:Play()
		
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
		
		local explosion = template:Clone()
		
		explosion.Position = pos
		explosion.Parent = orb
	end
end