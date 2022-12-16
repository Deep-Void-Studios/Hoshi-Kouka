local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

local ContextItem = Knit.CreateController({ Name = "Context/Item" })

local data

function ContextItem:KnitStart()
	local DataManager = Knit.GetService("DataManager")
	data = DataManager:Get()
end

local function equip(SUBJECT, slot)
	local signal = ClientComm:GetSignal(SUBJECT.Id)

	signal:Fire("Equip", slot)
end

local function unequip(slot)
	local equipmentId = data:Get().Equipment
	local signal = ClientComm:GetSignal(equipmentId)

	signal:Fire("Unequip", slot)
end

local function drop(SUBJECT)
	local signal = ClientComm:GetSignal(SUBJECT.Id)

	signal:Fire("Drop", 1)
end

local function dropAll(SUBJECT)
	local signal = ClientComm:GetSignal(SUBJECT.Id)
	local item = SUBJECT

	signal:Fire("Drop", item.Amount)
end

ContextItem.Equip = {
	Name = "Equip",
	Place = 101,
	AlwaysOn = true,
	Subcategory = {
		Primary = {
			Name = "Primary",
			Place = 101,
			Action = { equip, { "SUBJECT", "Primary" } },
		},

		Secondary = {
			Name = "Secondary",
			Place = 102,
			Action = { equip, { "SUBJECT", "Secondary" } },
		},

		Pickaxe = {
			Name = "Pickaxe",
			Place = 201,
			Action = { equip, { "SUBJECT", "Pickaxe" } },
		},

		Axe = {
			Name = "Axe",
			Place = 202,
			Action = { equip, { "SUBJECT", "Axe" } },
		},

		Shovel = {
			Name = "Shovel",
			Place = 203,
			Action = { equip, { "SUBJECT", "Shovel" } },
		},

		Item1 = {
			Name = "Item 1",
			Place = 301,
			AlwaysOn = true,
			Action = { equip, { "SUBJECT", "Item1" } },
		},

		Item2 = {
			Name = "Item 2",
			Place = 302,
			AlwaysOn = true,
			Action = { equip, { "SUBJECT", "Item2" } },
		},

		Item3 = {
			Name = "Item 3",
			Place = 303,
			AlwaysOn = true,
			Action = { equip, { "SUBJECT", "Item3" } },
		},

		Item4 = {
			Name = "Item 4",
			Place = 304,
			AlwaysOn = true,
			Action = { equip, { "SUBJECT", "Item4" } },
		},

		Item5 = {
			Name = "Item 5",
			Place = 305,
			AlwaysOn = true,
			Action = { equip, { "SUBJECT", "Item5" } },
		},
	},
}

ContextItem.Unequip = {
	Name = "Unequip",
	Place = 102,
	Action = { unequip, { "SLOT" } },
}

ContextItem.Drop = {
	Name = "Drop",
	Place = 999,
	Action = { drop, { "SUBJECT" } },
}

ContextItem.DropAll = {
	Name = "Drop All",
	Place = 1000,
	Action = { dropAll, { "SUBJECT" } },
}

return ContextItem
