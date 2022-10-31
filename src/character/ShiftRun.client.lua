local Humanoid : Humanoid = script.Parent:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

local BaseSpeed = Humanoid.WalkSpeed

UIS.InputBegan:Connect(function(input, ignored)
	if input.KeyCode == Enum.KeyCode.LeftShift and not ignored then
		Humanoid.WalkSpeed = BaseSpeed*1.5
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if Humanoid.WalkSpeed == BaseSpeed*1.5 then
			Humanoid.WalkSpeed = BaseSpeed
		end
	end
end)