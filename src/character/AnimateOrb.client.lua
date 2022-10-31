local RS = game:GetService("RunService")
local player = game.Players.LocalPlayer
local orb = workspace:WaitForChild("Spawn"):WaitForChild("CreationOrb")

local rings = {orb:WaitForChild("Red"), orb:WaitForChild("Green"), orb:WaitForChild("Blue")}
local speeds = {
	Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)/30,
	Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)/30,
	Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)/30,
}

local enabled = false

while wait(1) do
	if player.Character then
		local root = player.Character.HumanoidRootPart

		if (root.Position - orb.Position).Magnitude < 64 then
			if not enabled then
				enabled = true
				RS:BindToRenderStep("CreationOrb", 500, function()
					for i, ring : BasePart in pairs(rings) do
						local delta = speeds[i]

						ring:PivotTo(ring.CFrame * CFrame.Angles(delta.X, delta.Y, delta.Z))
					end
				end)
			end
		else
			if enabled then
				enabled = false
				RS:UnbindFromRenderStep("CreationOrb")
			end
		end
	else
		if enabled then
			enabled = false
			RS:UnbindFromRenderStep("CreationOrb")
		end
	end
end


