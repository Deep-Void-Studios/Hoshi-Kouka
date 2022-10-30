local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local modifier = require(script.Parent.Modifier)

local Trait = Knit.CreateService {
	Name = "Trait",
	Client = {}
}

Trait.__Class = Trait
Trait.__ClassName = "Trait"

function Trait:New(data)
	local table = setmetatable({
		Name = "",
		Description = "",
		Type = "Body",
		Cost = 0,
		Modifiers = {}
	}, self)

	if data then
		for i, v in pairs(data) do
			table[i] = v
		end
	end

	self.__index = self

	return table
end

return Trait
