-- Variables
local playerGui = game.Players.LocalPlayer.PlayerGui
local UIS = game:GetService("UserInputService")
local animLib = require(game:GetService("ReplicatedStorage").Libraries.ToggleGui)
local events = game:GetService("ReplicatedStorage").Events
local toggleEvent = events.User.Gui.Toggle

-- Loop through all children of PlayerGui
for _, gui in pairs(playerGui:GetChildren()) do
	-- Check if it's a GUI
	if gui:IsA("ScreenGui") then
		-- Set up GUI for toggle animation
		animLib.setup(gui)

		-- Get keybind
		local keybind = gui:GetAttribute("keybind")

		-- Check if it has a keybind
		if keybind then
			-- Toggle GUI on press
			UIS.InputBegan:Connect(function(input, gameProcessedEvent)
				if input.KeyCode == Enum.KeyCode[keybind] and not gameProcessedEvent then
					animLib.toggle(gui)
				end
			end)
		end

		-- Toggle GUI when requested
		toggleEvent.Event:Connect(function(request)
			if request == gui then
				animLib.toggle(gui)
			end
		end)

		-- Enable if it should be enabled by default, else: disable
		if gui:GetAttribute("defaultToggle") then
			animLib.makeOpaque(gui)
		else
			animLib.makeTransparent(gui)
		end
	end
end
