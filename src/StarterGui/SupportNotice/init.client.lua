local RunService = game:GetService("RunService")
local PlayerGui = script.Parent

if not RunService:IsStudio() then
	script.Donations.Enabled = true
	script.Donations.Parent = PlayerGui
end
