--local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local BaseClass = require(script.Parent)

local Inventory = BaseClass:__MakeClass("Inventory")

Inventory.__Replicated = {
	Volume = true,
	MaxVolume = true,
	Weight = true,
	MaxWeight = true,
	Id = true,
}

Inventory.__Defaults = {
	Volume = 0,
	MaxVolume = 40,
	Weight = 0,
	MaxWeight = 100,
}

local function truncate(number: number): string
	local num = tostring(number)
	local place = string.find(num, ".")

	if place then
		return string.sub(num, 1, place + 2)
	else
		return num
	end
end

local function sort(a, b)
	local aType = a.Type
	local bType = b.Type
	local aName = a.Name
	local bName = b.Name

	if aType == bType then
		if aName == bName then
			return table.concat(a) < table.concat(b)
		else
			return aName < bName
		end
	else
		return aType < bType
	end
end

local function deepCompare(a, b)
	-- Loop through table A's properties
	for i, aValue in pairs(a) do
		if i ~= "Amount" then
			-- Check table B's corresponding property
			local bValue = b[i]

			-- Check if A's property and B's property are both tables
			if type(aValue) == "table" and type(bValue) == "table" then
				-- Deep compare both tables
				if not deepCompare(aValue, bValue) then
					-- Return false if different
					return false
				end

				-- If they are not tables, check if they are the same
			elseif aValue ~= bValue then
				-- Return false if different
				return false
			end
		end
	end

	-- If no differences were found, return true
	return true
end

-- Returns true if the 2 tables are the same.
local function same(itemA, itemB)
	-- Perform small efficient checks first to reduce lag
	if itemA.Name ~= itemB.Name then
		return false
	elseif itemA.Type ~= itemB.Type then
		return false
	end

	-- Perform a deep compare.
	return deepCompare(itemA, itemB)
end

local function addItem(inventory, item)
	for i, other in pairs(inventory:GetItems()) do
		other.Index = i

		if same(item, other) then
			other:AddAmount(item.Amount)
			break
		else
			if not sort(item, other) then
				table.insert(inventory, i, item)
			end
		end
	end
end

function Inventory:ChildAdded(child)
	if child.__ClassName == "Item" then
		addItem(self, child)

		self.Volume += child.Properties.Volume
		self.Weight += child.Properties.Weight
	else
		error("Inventory does not accept non-items.")
	end

	self.Updated:Fire()
end

function Inventory:ChildRemoved(index)
	table.remove(self, index)

	for i, item in pairs(self:GetItems()) do
		item.Index = i
	end

	self.Updated:Fire()
end

function Inventory:CanHold(item)
	-- *STRINGS* for display only.
	local itemVolume = truncate(item.Properties.Volume)
	local remainingVolume = truncate(self.MaxVolume - self.Volume)

	if self.Volume + item.Properties.Volume > self.MaxVolume then
		return false, "Volume (" .. itemVolume .. ") exceeds remaining volume (" .. remainingVolume .. ")."
	end

	-- *STRINGS* for display only.
	local itemWeight = truncate(item.Properties.Weight)
	local remainingWeight = truncate(self.MaxWeight - self.Weight)

	if self.Weight + item.Properties.Weight > self.MaxWeight then
		return false, "Weight (" .. itemWeight .. ") exceeds remaining weight (" .. remainingWeight .. ")."
	end

	return true
end

function Inventory:GetItems()
	local items = {}

	for _, item in ipairs(self) do
		table.insert(items, item)
	end

	return items
end

return Inventory
