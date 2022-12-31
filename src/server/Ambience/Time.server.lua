local lighting = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")
local presets = ServerStorage.LightingPresets
local dayLighting = require(presets.day).graphics
local nightLighting = require(presets.night).graphics
local daySound = require(presets.day).sound
local nightSound = require(presets.night).sound

-- Config
local mins = 40
local dayStart = 8
local dayEnd = 16
local nightStart = 20
local nightEnd = 4

-- Gets a number between 2 numbers using a fraction.
local function between(A, B, fraction)
	if typeof(A) == "Color3" then
		return A:Lerp(B, fraction)
	else
		return (B - A) * fraction + A
	end
end

-- Gets a fraction using a number between 2 numbers; reverse of between().
local function reverseBetween(A, B, number)
	return (number - A) / (B - A)
end

local function setValues(obj, values)
	for attribute, value in pairs(values) do
		obj[attribute] = value
	end
end

local function setGraphics(graphics)
	for obj, values in pairs(graphics) do
		if obj == "Lighting" then
			setValues(lighting, values)
		else
			setValues(lighting[obj], values)
		end
	end
end

local function lerpGraphics(timeA, timeB, from, to)
	local t = lighting.ClockTime
	local fraction = reverseBetween(timeA, timeB, t)
	local graphics = {}

	for obj, tab in pairs(from) do
		graphics[obj] = {}
		for key, value in pairs(tab) do
			local fromVal = value
			local toVal = to[obj][key]
			graphics[obj][key] = between(fromVal, toVal, fraction)
		end
	end

	setGraphics(graphics)
end

local function lerpSounds(timeA, timeB, from: Sound, to: Sound)
	local t = lighting.ClockTime
	local fraction = reverseBetween(timeA, timeB, t)

	from.Volume = from:GetAttribute("DefaultVolume") * (1 - fraction)
	to.Volume = to:GetAttribute("DefaultVolume") * fraction
end

local function update()
	local t = lighting.ClockTime
	if t > nightEnd and t < dayStart then
		-- Time is morning.
		lerpGraphics(nightEnd, dayStart, nightLighting, dayLighting)
		lerpSounds(nightEnd, dayStart, nightSound, daySound)
	elseif t > dayEnd and t < nightStart then
		-- Time is sunset.
		lerpGraphics(dayEnd, nightStart, dayLighting, nightLighting)
		lerpSounds(dayEnd, nightStart, daySound, nightSound)
	elseif t > nightStart or t < nightEnd then
		-- Time is night.
		setGraphics(nightLighting)
		daySound.Volume = 0
		nightSound.Volume = nightSound:GetAttribute("DefaultVolume")
	else
		-- Time is day.
		setGraphics(dayLighting)
		nightSound.Volume = 0
		daySound.Volume = daySound:GetAttribute("DefaultVolume")
	end
end

while wait(0.1) do
	lighting.ClockTime = lighting.ClockTime + 24 / (mins * 60) * 0.1
	update()
end
