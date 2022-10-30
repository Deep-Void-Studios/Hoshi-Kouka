local template = script.explosion

while wait(0.1) do
	local nearby = false
	
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local char = v.Character
			local root = char.HumanoidRootPart
			
			if (root.Position - script.Parent.Position).Magnitude < 24 then
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
		
		local pos = script.Parent.Position + displacement
		
		local sound : Sound = script["sound"..math.random(1,6)]:Clone()
		sound.Parent = script.Parent
		sound:Play()
		
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
		
		local explosion = template:Clone()
		
		explosion.Position = pos
		explosion.Parent = script.Parent
	end
end