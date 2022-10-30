local module = {}

local pathfind = require(script.Parent.HoshiUtils.Pathfind)
local sfx = game:GetService("SoundService").SFX

function module:Play(path)
	local sound:Sound = pathfind(sfx, path):Clone()
	
	sound.Parent = game:GetService("SoundService")
	
	sound:Play()
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
	
	return sound
end

return module
