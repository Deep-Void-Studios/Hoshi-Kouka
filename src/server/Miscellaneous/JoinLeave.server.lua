local Players = game:GetService("Players")
local SFX = game:GetService("SoundService").SFX
local joinSound = SFX.Miscellaneous.join
local leaveSound = SFX.Miscellaneous.leave

Players.PlayerAdded:Connect(function()
	local sound = joinSound:Clone()

	sound.Parent = game.SoundService
	sound.Playing = true

	sound.Stopped:Connect(function()
		sound:Destroy()
	end)
end)

Players.PlayerRemoving:Connect(function()
	local sound = leaveSound:Clone()

	sound.Parent = game.SoundService
	sound.Playing = true

	sound.Stopped:Connect(function()
		sound:Destroy()
	end)
end)
