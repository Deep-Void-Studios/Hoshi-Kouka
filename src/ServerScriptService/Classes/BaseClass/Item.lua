local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Item = BaseClass:__MakeClass("Item")

local ItemService
local NotificationService
local HoshiUtils

Item.__Replicated = {
	Name = true,
	Description = true,
	Amount = true,
	Model = true,
	Image = true,
	Properties = true,
	Actions = true,
	Id = true
}

Item.Defaults = {
	Name = "",
	Description = "",
	Amount = 1,
	Model = "Warped Cube",
	Image = 0,

	Properties = {
		Volume = 0,
		Weight = 0
	},

	Actions = {
		Drop = true,
		DropAll = true
	}
}

function Item:KnitStart()
	ItemService = Knit.GetService("ItemService")
	NotificationService = Knit.GetService("NotificationService")
	HoshiUtils = Knit.GetService("HoshiUtils")
end

-- Add (or subtract with negatives) to the item's amount.
function Item:AddAmount(n)
	self.Amount += n
	
	if self.Amount <= 0 then
		self:Destroy()
	end
end

-- Drop an amount of items.
function Item:Drop(n, cframe)
	n = self:NumClamp(n)
	
	self:AddAmount(-n)
	
	local item = self:Clone()
	item.Amount = n
	
	ItemService:Spawn(item)
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

--[[ Client Operations ]]--

-- Drop function received from client.
function Item:__ClientDrop(n)
	-- Check if item has been destroyed (usually when amount <= 0)
	if not self.Name then return false end
	self:Drop(n)
end

return Item