local hoshiutils = require(game:GetService("ReplicatedStorage").Libraries.HoshiUtils)
local searchpath = hoshiutils.Pathfind
local copy = hoshiutils.DeepCopy

local writelib = {
	insertItem = function(replica, index, item)
		local path = {"Inventory"}
		local inventory = searchpath(replica.Data, path)
		local oldItem

		for i = index, #inventory+1 do
			if inventory[i] then
				oldItem = copy(inventory[i])

				replica:ArraySet(path, i, item)

				item = oldItem
			else
				replica:ArrayInsert(path, item)
			end
		end
	end,
	
	modItem = function(replica, index, path, value)
		replica:SetValue({"Inventory", index, table.unpack(path)}, value)
	end,
	
	removeItem = function(replica, index)
		replica:ArrayRemove({"Inventory"}, index)
	end,
	
	
}

return writelib
