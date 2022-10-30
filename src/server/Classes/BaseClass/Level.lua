local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Level = BaseClass:__MakeClass("Level")

-- All values replicated to the client should be written here.
Level.__Replicated = {
	Name = true,
	Description = true,
	Level = true,
	Experience = true,
	Points = true,
	Potential = true,
	Associations = true,
	Id = true
}

Level.Defaults = {
	Name = "",
	Description = "",
	Level = 0,
	Experience = 0,
	Potential = 100,
	Associations = {}
}

function Level:NewBase(data)
	local object = Level:New({
		Level = 1,
		Experience = 25 * 1.5,
		Points = 0,
	})
	
	for i, v in pairs(data) do
		if i == "Id" or i == "AuthorizedUsers" or i == "Updated" or i == "Removing" or i == "Comm" then
			continue
		end

		object[i] = v
	end
	
	return object
end

function Level:XPCheck()
	if self.Experience > 25 * (1.5^self.Level + 1) then
		self.Level += 1
		self:XPCheck()
	elseif self.Experience < 25 * (1.5^self.Level) then
		self.Level -= 1
		self:XPCheck()
	end
end

function Level:AddLevel(amount)
	self.Level += amount
	self.Experience = 25 * (1.5^self.Level)
	self.Updated:Fire()
end

function Level:AddXP(amount)
	self.Experience += amount
	self:XPCheck()
	self.Updated:Fire()
end

function Level:AddPotential(amount)
	self.Potential += amount
	self.Updated:Fire()
end

function Level:SetLevel(amount)
	self.Level = amount
	self.Experience = 25 * (1.5^self.Level)
	self.Updated:Fire()
end

function Level:SetXP(amount)
	self.Experience = amount
	self:XPCheck()
	self.Updated:Fire()
end

function Level:SetPotential(amount)
	self.Potential = amount
	self.Updated:Fire()
end

return Level
