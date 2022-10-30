local clouds = game.Workspace.Terrain.Clouds
local atmosphere = game.Lighting.Atmosphere

local clearColor = Color3.fromRGB(255, 255, 255)
local rainColor = Color3.fromRGB(113, 116, 134)
local skyColor = Color3.fromRGB()
local fogColor = Color3.fromRGB(152, 152, 152)
local fogDecay = Color3.fromRGB(219, 219, 220)

local coverMin, coverMax = 0.25, 1
local cloudMin, cloudMax = 0, 1
local densityMin, densityMax = 0.3, 1
local hazeMin, hazeMax = 0, 3

local rain = 0
local fog = 0
local cloudiness = 0.5

local t = 0

local function between(decimal, min, max)
	max = max - min
	max = max * decimal
	max = min + max
	return max
end

while wait() do
	t = t + 0.01
	cloudiness = math.clamp(cloudiness+math.noise(t, 0.5)/1000, 0, 1)
	clouds.Cover = between(cloudiness, cloudMin, cloudMax)
end
