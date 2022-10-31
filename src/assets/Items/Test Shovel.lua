local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Test Shovel",
	Description = "An average shovel for testing purposes.",
	Type = "Tool",
	Amount = 1,

	Properties = {
		Volume = 8,
		Weight = 16,

		Tool = {
			Type = "Shovel",
			Tier = 2,
			Damage = 100,
			Delay = 1
		},

		Durability = 1024
	},

	Actions = {
		Drop = true,
		Equip = {Shovel = true},
		DropAll = true
	},

	Model = "Test Shovel",

	Image = "rbxassetid://10798425709"
}

return process(data)
