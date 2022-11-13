local s: Sound = game:GetService("SoundService").SFX.Miscellaneous.respawn:Clone()
s.Parent = game.SoundService
s.Playing = true
s.Stopped:Connect(function()
	s:Destroy()
end)
