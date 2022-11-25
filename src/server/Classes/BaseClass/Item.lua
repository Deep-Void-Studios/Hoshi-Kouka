local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local BaseClass = require(script.Parent)

local Item = BaseClass:__MakeClass("Item")

local ItemService
local DataManager

Item.__Replicated = {
	Name = true,
	Description = true,
	Amount = true,
	Model = true,
	Image = true,
	Properties = true,
	Actions = true,
	Id = true,
}

Item.Defaults = {
	Name = "",
	Description = "",
	Amount = 1,
	Model = "Warped Cube",
	Image = 0,

	Properties = {
		Volume = 0,
		Weight = 0,
	},

	Actions = {
		Drop = true,
		DropAll = true,
	},
}

function Item:KnitStart()
	ItemService = Knit.GetService("ItemService")
	DataManager = Knit.GetService("DataManager")
end

-- Add (or subtract with negatives) to the item's amount.
function Item:AddAmount(n)
	self.Amount += n

	if self.Amount <= 0 then
		self:Destroy()
	end
end

-- Split a stack of items.
function Item:Split(n)
	n = self:NumClamp(n)

	local new = self:Clone()
	new.Amount = n

	if n == self.Amount then
		self:Destroy()
	end

	return new
end

-- Drop an amount of items.
function Item:Drop(n, cframe)
	local item = self:Split(n)

	ItemService:Spawn(item, cframe)
end

-- Clamp n so that it cannot be greater than the item's amount.
-- Mainly for stuff like dropping items so that you can't drop more than you have.
function Item:NumClamp(n)
	if n > self.Amount then
		return self.Amount
	else
		return n
	end
end

function Item:EquipTo(equipment, slot)
	if self.Parent then
		self.Parent:ChildRemoved(self.Index)
	end

	self.Parent = equipment
	self.Index = slot
	equipment:Equip(self, slot)
end

--[[ Client Operations ]]
--

-- Drop function received from client.
function Item:__ClientDrop(player, n)
	-- Check if item has been destroyed (usually when amount <= 0)
	if not self.Name then
		return false
	end

	local char = player.Character

	if not char then
		return
	end

	local primary = char.PrimaryPart
	local cframe = primary.CFrame + (primary.CFrame.LookVector * 5)

	self:Drop(n, cframe)
end

-- Weapon
-- Pickaxe
-- Axe
-- Shovel
-- Item[1-5]

-- Head
-- Neck
-- Chest
-- Arms
-- Hands
-- Ring
-- Legs
-- Feet
-- Backpack
-- Accessory

function Item:__ClientEquip(slot)
	assert(self.Player, "Player not found.")

	if self.Actions.Equip[slot] then
		local data = DataManager:Get(self.Player)

		self:EquipTo(data.Equipment, slot)
	else
		warn("Attempted to equip to invalid slot.")
	end
end

return Item
