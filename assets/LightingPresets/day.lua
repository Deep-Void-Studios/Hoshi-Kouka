local module = {}

module.graphics = {
	["Lighting"] = {
		["Ambient"] = Color3.fromRGB(0, 0, 0),
		["Brightness"] = 2,
		["ColorShift_Top"] = Color3.fromRGB(0, 0, 0),
		["EnvironmentDiffuseScale"] = 1,
		["EnvironmentSpecularScale"] = 1,
		["OutdoorAmbient"] = Color3.fromRGB(70, 70, 70),
		["ExposureCompensation"] = 0
	},
	["Atmosphere"] = {
		["Density"] = 0.25
	},
	["Bloom"] = {
		["Threshold"] = 2
	}
}

module.sound = game:GetService("SoundService").SFX.Ambient.Forest.Day["Neighborhood Birds 2 (SFX)"]

return module
