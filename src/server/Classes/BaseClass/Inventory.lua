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

local baseNew = Inventory.New

function Inventory:New(...)
	local inv = baseNew(self, ...)

	inv.Updated:Connect(function()
		inv:__CorrectWV()
	end)

	return inv
end

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
		if a.__ClassName then
			if a.__DoNotCopy[i] then
				continue
			end
		end

		if i == "Amount" then
			continue
		end

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

	-- If no differences were found, return true
	return true
end

-- Returns true if the 2 tables are the same.
local function same(itemA, itemB)
	-- Perform small efficient checks first to reduce lag
	if itemA.Name ~= itemB.Name or itemA.Type ~= itemB.Type then
		return false
	end

	-- Perform a deep compare.
	return deepCompare(itemA, itemB)
end

local function addItem(inventory, item)
	local items = inventory:GetItems()

	if #items > 0 then
		for i = 1, #inventory + 1 do
			if i == #inventory + 1 then
				table.insert(inventory, item)
				item.Index = i
				break
			end

			local other = items[i]

			if same(item, other) then
				other:AddAmount(item.Amount)
				break
			elseif not sort(item, other) then
				table.insert(inventory, i, item)
				item.Index = i
				break
			end
		end
	else
		table.insert(inventory, 1, item)
		item.Index = 1
	end

	inventory:CorrectIndices()
end

-- Receive child and set to proper index.
function Inventory:ChildAdded(child, customIndex)
	-- Make sure it's an item.
	assert(child.__ClassName == "Item", "Inventory does not accept non-items.")

	-- Check if a custom index is specified.
	-- DO NOT USE CUSTOM INDEX UNLESS LOADING FROM A SAVE FILE.
	-- CAN CAUSE MAJOR ISSUES OTHERWISE.
	if customIndex then
		-- Set item to the given index.
		child.Index = customIndex
		self[customIndex] = child
	else
		-- Set item to the proper index.
		addItem(self, child)
	end

	-- Fire updated
	self.Updated:Fire()
end

function Inventory:ChildRemoved(index)
	table.remove(self, index)

	self:CorrectIndices()

	self.Updated:Fire()
end

function Inventory:CorrectIndices()
	for i, item in pairs(self:GetItems()) do
		item.Index = i
	end
end

function Inventory:__CorrectWV()
	self.Volume = 0
	self.Weight = 0

	for _, item in pairs(self:GetItems()) do
		self.Volume += item.Properties.Volume * item.Amount
		self.Weight += item.Properties.Weight * item.Amount
	end
end

function Inventory:CanHold(item)
	-- *STRINGS* for display only.
	local itemVolume = truncate(item.Properties.Volume * item.Amount)
	local remainingVolume = truncate(self.MaxVolume - self.Volume)

	if self.Volume + (item.Properties.Volume * item.Amount) > self.MaxVolume then
		return false, "Volume (" .. itemVolume .. ") exceeds remaining volume (" .. remainingVolume .. ")."
	end

	-- *STRINGS* for display only.
	local itemWeight = truncate(item.Properties.Weight * item.Amount)
	local remainingWeight = truncate(self.MaxWeight - self.Weight)

	if self.Weight + (item.Properties.Weight * item.Amount) > self.MaxWeight then
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
