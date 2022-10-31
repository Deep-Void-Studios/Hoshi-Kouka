local closeMenu = game:GetService("ReplicatedStorage").Events.User.Gui.Toggle

local function getGui(object)
	if object.Parent.ClassName == "ScreenGui" then
		return object.Parent
	else
		return getGui(object.Parent)
	end
end

local menu = getGui(script.Parent)

script.Parent.Activated:Connect(function()
	closeMenu:Fire(menu)
end)
