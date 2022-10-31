local module = {}
local music = game:GetService("SoundService").Music
local TweenService = game:GetService("TweenService")
local hoshiutils = script.Parent.HoshiUtils
local pathfind = require(hoshiutils.Pathfind)

local defaultInfo = TweenInfo.new(
	16,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In
)

function module:GetRandom(path)
	local songs = pathfind(music, path):GetChildren()
	
	return songs[math.random(1, #songs)]
end

function module:Play(path, info)
	local song:Sound = pathfind(music, path)
	local info = info or defaultInfo
	assert(song, "Song not found.")
	assert(song:IsA("Sound"), "Song is not a sound.")
	
	-- Set OriginalVolume if not found.
	if not song:GetAttribute("OriginalVolume") then
		song:SetAttribute("OriginalVolume", song.Volume)
	end
	
	local endInfo = {Volume = song:GetAttribute("OriginalVolume")}
	
	song.Volume = 0
	TweenService:Create(song, info, endInfo):Play()
	song:Play()
	module.Playing = song
	
	song.Ended:Connect(function()
		module.Playing = nil
	end)
end

function module:Stop(info, yield)
	if not module.Playing then return end
	
	local endInfo = {Volume = 0}
	info = info or defaultInfo
	
	local tween = TweenService:Create(module.Playing, endInfo, info)
	tween:Play()
	
	if not yield then
		return true
	else
		tween.Completed:Wait()
		return true
	end
end

return module
