--local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
--local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Status = BaseClass:__MakeClass("Status")

Status.__Replicated = {
	Vitals = true,
	Traits = true,
	Effects = true,
	Id = true,
}

Status.__Defaults = {
	Vitals = {
		Health = 20,
		MaxHealth = 20,

		Hunger = 20,
		MaxHunger = 20,

		Thirst = 20,
		MaxThirst = 20,

		Stamina = 20,
		MaxStamina = 20,

		Mana = 20,
		MaxMana = 20,
	},

	Traits = {},
	Effects = {},
}

function Status:RestoreVital(name, n)
	self.Vitals[name] += n
	self.Vitals[name] = math.clamp(self.Vitals[name], 0, self.Vitals["Max" .. name] * 2)
	self.Updated:Fire()
end

function Status:DrainVital(name, n)
	self.Vitals[name] -= n
	self.Vitals[name] = math.clamp(self.Vitals[name], 0, self.Vitals["Max" .. name] * 2)
	self.Updated:Fire()
end

return Status
