local player = game:GetService("Players").LocalPlayer
local lighting = game:GetService("Lighting")
local music = require(game:GetService("ReplicatedStorage").Libraries.MusicPlayer)

local rarity = 600

if player.Name == "AimiAmano" then
	script:SetAttribute("Region", "Mochizuki")
end

local function GetContext()
	local region = script:GetAttribute("Region")
	local t
	
	if lighting.ClockTime < 6 then
		t = "Night"
	elseif lighting.ClockTime < 18 then
		t = "Day"
	else
		t = "Night"
	end
	
	return region, t
end

local function PlayRandom()
	local region, t = GetContext()
	
	if not music.Playing then
		local song = music:GetRandom({region, t})
		
		music:Play({region, t, song.Name})
	end
end

while wait(1) do
	if math.random(1, rarity) == 1 then
		PlayRandom()
	end
end
