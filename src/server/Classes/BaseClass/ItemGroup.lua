local BaseClass = require(script.Parent)

local ItemGroup = BaseClass:__MakeClass("ItemGroup")

function ItemGroup:ChildAdded(object, index)
	index = index or #self + 1

	table.insert(self, index, object)

	object.Index = index
end

return ItemGroup
