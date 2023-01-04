local BaseClass = require(script.Parent)

local ItemGroup = BaseClass:__MakeClass("ItemGroup")

local Inventory = BaseClass:__MakeClass("Inventory")

function ItemGroup:ChildAdded(object, index)
	index = index or #self + 1

	table.insert(self, index, object)

	object.Index = index
end

function ItemGroup:GetItems()
    local items = {}

    for _, item in ipairs(self) do
        table.insert(items, item)
    end

    return items
end

function ItemGroup:Transfer(inventory)
	local items = inventory:GetItems()

	for _, item in pairs(items) do
		item:SetParent(inventory)
	end
end

return ItemGroup
