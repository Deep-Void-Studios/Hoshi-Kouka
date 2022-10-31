local gui = script.Parent

local UIS = game:GetService("UserInputService")
local animLib = require(game:GetService("ReplicatedStorage").Libraries.ToggleGui)
local events = game:GetService("ReplicatedStorage").Events
local toggleEvent = events.User.Gui.Toggle

local default = gui:GetAttribute("defaultToggle")
local keybind = gui:GetAttribute("keybind")

animLib.setup(gui)

if default then
	animLib.makeOpaque(gui)
else
	animLib.makeTransparent(gui)
end

toggleEvent.Event:Connect(function(menu)
	if menu == gui then
		animLib.toggle(gui)
	end
end)

UIS.InputBegan:Connect(function(input, ignored)
	if keybind ~= "" then
		if not ignored and input.KeyCode == Enum.KeyCode[keybind] then
			animLib.toggle(gui)
		end
	end
end)

