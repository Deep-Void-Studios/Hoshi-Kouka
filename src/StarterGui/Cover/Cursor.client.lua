local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui
local UIS = game:GetService("UserInputService")
local cover = script.Parent

local function enableCursor()
	cover.Enabled = true
end

local function disableCursor()
	cover.Enabled = false
end

for i, gui : ScreenGui in pairs(PlayerGui:GetChildren()) do
	if gui:GetAttribute("ShowMouse") then
		gui.Changed:Connect(function()
			local showMouse = false
			
			for i, gui in pairs(PlayerGui:GetChildren()) do
				if gui:GetAttribute("ShowMouse") then
					if gui.Enabled then
						showMouse = true
						break
					end
				end
			end
			
			if showMouse then
				enableCursor()
			else
				disableCursor()
			end
		end)
	end
end

UIS.InputBegan:Connect(function(input, ignored)
	if input.KeyCode == Enum.KeyCode.LeftAlt and not ignored then
		enableCursor()
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftAlt then
		disableCursor()
	end
end)