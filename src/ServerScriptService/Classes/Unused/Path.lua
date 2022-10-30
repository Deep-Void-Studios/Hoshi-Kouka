local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local Path = Knit.CreateService {
	Name = "Path",
	Client = {}
}

export type Path = {
	[number] : string
}

Path.__Class = Path
Path.__ClassName = "Path"

function Path:New(data) : Path
	local table = setmetatable({}, self)

	if data then
		for i, v in pairs(data) do
			table[i] = v
		end
	end

	self.__index = self

	return table
end

function Path:Traverse(table)
	assert(type(table) == "table", "Received non-table, type: "..type(table)..".")
	
	local result = table
	
	for i, v in ipairs(self) do
		result = self[i]
	end
	
	return result
end

return Path
