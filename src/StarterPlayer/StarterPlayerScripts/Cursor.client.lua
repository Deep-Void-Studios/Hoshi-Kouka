local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local mouse = player:GetMouse()
local firstPerson = false
local head

local function IsFirstPerson()
	local magnitude = (head.CFrame.p - camera.CFrame.p).Magnitude
	return magnitude < 1
end

local function setCursor(inFirst)
	if inFirst then
		mouse.Icon = "http://www.roblox.com/asset?id=950896037"
	else
		mouse.Icon = ""
	end
end

RunService.RenderStepped:Connect(function()
	local char = player.Character
	
	if char then
		head = char:WaitForChild("Head", 16)
		
		if head then
			local inFirst = IsFirstPerson()
			
			if inFirst ~= firstPerson then
				firstPerson = inFirst
				
				setCursor(inFirst)
			end
		end
	end
end)