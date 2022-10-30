local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local modifier = require(script.Parent.Modifier)

local Effect = Knit.CreateService {
	Name = "Effect",
	Client = {}
}

Effect.__Class = Effect
Effect.__ClassName = "Effect"

function Effect:New(data) : Effect
	local table = setmetatable({
		Name = "",
		Description = "",
		Level = 0,
		Duration = 0
	}, self)

	if data then
		for i, v in pairs(data) do
			table[i] = v
		end
	end

	self.__index = self

	return table
end

return Effect
