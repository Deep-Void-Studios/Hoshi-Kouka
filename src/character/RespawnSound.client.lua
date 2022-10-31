local s = script:WaitForChild("sound"):Clone()
s.Parent = game.SoundService
s.Playing = true
wait(10)
s:Destroy()