local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Test Pickaxe",
	Description = "An average pickaxe for testing purposes.",
	Type = "Tool",
	Amount = 1,

	Properties = {
		Volume = 8,
		Weight = 16,

		Tool = {
			Type = "Pickaxe",
			Tier = 2,
			Damage = 100,
			Delay = 1
		},

		Durability = 1024
	},

	Actions = {
		Drop = true,
		Equip = {Pickaxe = true},
		DropAll = true
	},

	Model = "Test Pickaxe",

	Image = "rbxassetid://10714137631"
}

return process(data)
