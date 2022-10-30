local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local Modifier = Knit.CreateService {
	Name = "Modifier",
	Client = {}
}

Modifier.__Class = Modifier
Modifier.__ClassName = "Modifier"

function Modifier:New(data)
	local table = setmetatable({}, self)
	
	if data then
		for i, v in pairs(data) do
			table[i] = v
		end
	end

	self.__index = self

	return table
end

return Modifier
