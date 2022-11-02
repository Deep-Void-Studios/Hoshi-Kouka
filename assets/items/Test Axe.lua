local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Test Axe",
	Description = "An average axe for testing purposes.",
	Type = "Tool",
	Amount = 1,

	Properties = {
		Volume = 8,
		Weight = 16,
		
		Tool = {
			Type = "Axe",
			Tier = 2,
			Damage = 100,
			Delay = 1
		},
		
		Durability = 1024
	},

	Actions = {
		Drop = true,
		Equip = {Axe = true},
		DropAll = true
	},

	Model = "Test Axe",

	Image = "rbxassetid://8479255949"
}

return process(data)
