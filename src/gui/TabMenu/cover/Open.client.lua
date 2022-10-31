local container = script.Parent.center
local toggleGui = require(game.ReplicatedStorage.Libraries.ToggleGui)
local player = game.Players.LocalPlayer

for i, button in pairs(container:GetChildren()) do
	if button.Name ~= "Unbound" then
		local gui = button.Name
		local button : ImageButton = button.button
		
		button.Activated:Connect(function()
			toggleGui.toggle(player.PlayerGui[gui])
		end)
	end
end
