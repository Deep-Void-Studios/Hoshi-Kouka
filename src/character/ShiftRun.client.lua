local Humanoid: Humanoid = script.Parent:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

local BaseSpeed = Humanoid.WalkSpeed

Humanoid:SetAttribute("Running", false)

UIS.InputBegan:Connect(function(input, ignored)
	if input.KeyCode == Enum.KeyCode.LeftShift and not ignored then
		Humanoid.WalkSpeed = BaseSpeed * 2
		Humanoid:SetAttribute("Running", true)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift and Humanoid:GetAttribute("Running") then
		Humanoid.WalkSpeed = BaseSpeed
		Humanoid:SetAttribute("Running", false)
	end
end)
