local module = {}

module.graphics = {
	["Lighting"] = {
		["Ambient"] = Color3.fromRGB(0, 0, 0),
		["Brightness"] = 2,
		["ColorShift_Top"] = Color3.fromRGB(0, 0, 0),
		["EnvironmentDiffuseScale"] = 0,
		["EnvironmentSpecularScale"] = 0,
		["OutdoorAmbient"] = Color3.fromRGB(19, 19, 31),
		["ExposureCompensation"] = 0
	},
	["Atmosphere"] = {
		["Density"] = 0.5
	},
	["Bloom"] = {
		["Threshold"] = 1
	}
}

module.sound = game:GetService("SoundService").SFX.Ambient.Forest.Night["Malaysian Forest 4 (SFX)"]

return module
