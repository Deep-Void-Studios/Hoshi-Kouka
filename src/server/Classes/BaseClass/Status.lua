local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Status = BaseClass:__MakeClass("Status")

Status.__Replicated = {
	Vitals = true,
	Traits = true,
	Effects = true,
	Id = true
}

Status.__Defaults = {
	Vitals = {
		Health = 100,
		MaxHealth = 100,
		
		Hunger = 100,
		MaxHunger = 100,
		
		Thirst = 100,
		MaxThirst = 100,
		
		Stamina = 100,
		MaxStamina = 100,
		
		Mana = 100,
		MaxMana = 100
	},
	
	Traits = {},
	Effects = {}
}

function Status:DrainVital(name, n)
	self.Vitals[name] -= math.clamp(n, 0, self.Vitals["Max"..name]*2)
	self.Updated:Fire()
end

return Status
