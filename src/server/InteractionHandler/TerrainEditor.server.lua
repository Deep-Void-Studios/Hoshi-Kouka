local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local ItemService = Knit.GetService("ItemService")
local Notify = Knit.GetService("NotificationService")

local RS = game:GetService("ReplicatedStorage")
local terrain = workspace.Terrain
local events = RS.Events
local digEvent = events.Dig
local placeEvent = events.Place
-- Reach distance is 12, but an extra 2 is added in case of lag
local reachDistance = 12 + 2

local materials = require(RS.Libraries.TerrainMaterials)

local offset = Vector3.new(2, 2, 2)

local function getRegion(pos)
	return Region3.new(pos - offset, pos + offset)
end

local function getVoxel(region)
	local mats, occupancies = terrain:ReadVoxels(region, 4)

	return mats[1][1][1], occupancies[1][1][1]
end

local db_next = {}

local function debounce(player: Player)
	if db_next[player.UserId] then
		local nxt = db_next[player.UserId]

		if tick() >= nxt then
			return true
		else
			return false
		end
	else
		return true
	end
end

local function damageVoxel(region, damage, harvestable, player)
	local material, occupancy = getVoxel(region)
	local item = ItemService:GetItem(material.Name)

	if not harvestable then
		item = nil
	end

	local mats = { { { material } } }
	local occs

	local removed

	if occupancy >= damage then
		occs = { { { occupancy - damage } } }
		removed = damage
	else
		occs = { { { 0 } } }
		removed = occupancy
	end

	if item then
		item = item:Clone()
		item.Amount = removed

		local inventory = DataManager:Get(player).Inventory

		if not inventory:CanHold(item) then
			item:Destroy()
			return false
		else
			item:SetParent(inventory)
		end
	end

	terrain:WriteVoxels(region, 4, mats, occs)

	return removed, item
end

digEvent.OnServerInvoke = function(player, pos)
	local character = player.Character

	if character and debounce(player) then
		local root = character.HumanoidRootPart

		if (pos - root.Position).Magnitude < reachDistance then
			local region = getRegion(pos)

			local material = getVoxel(region)

			if material == Enum.Material.Air or material == Enum.Material.Water then
				Notify:Warn("Action Failed", "Attempted to dig air or water.", player)
				return false
			end

			material = materials:GetMaterial(material.Name)

			local damage, harvestable, delay = material:GetDamage(player)

			db_next[player.UserId] = tick() + (delay - 0.5) -- In case of lag up to 500 ms

			local removed = damageVoxel(region, damage, harvestable, player)

			if removed then
				return true
			else
				Notify:Warn("Action Failed", "Inventory is full.", player)
				return false
			end
		end
	end
end

local function placeVoxel(region, item, amount)
	local _, occupancy = getVoxel(region)

	local mats = { { { Enum.Material[item.Name] } } }
	local occs

	local placed

	if occupancy + amount < 1 then
		occs = { { { occupancy + amount } } }
		placed = amount
	else
		occs = { { { 1 } } }
		placed = 1 - occupancy
	end

	item:AddAmount(-placed)

	terrain:WriteVoxels(region, 4, mats, occs)
end

placeEvent.OnServerInvoke = function(player, pos, index, amount)
	local character = player.Character

	if character and debounce(player) then
		local root = character.HumanoidRootPart

		if (pos - root.Position).Magnitude < reachDistance then
			local item = DataManager:Get(player).Inventory[index]

			if not item then
				Notify:Warn("Action Failed", "Item does not exist.", player)
				return false
			end

			if not item.Type == "TerrainMaterial" then
				Notify:Warn("Action Failed", "Attempted to place non-material.", player)
				return false
			end

			local region = getRegion(pos)

			local material, occupancy = getVoxel(region)

			if occupancy >= 1 then
				Notify:Warn("Action Failed", "Attempted to place on a full voxel.", player)
				return false
			elseif occupancy > 0 then
				if material.Name ~= item.Name then
					Notify:Warn(
						"Action Failed",
						"Attempted to place different material on a partially filled voxel.",
						player
					)
					return false
				end
			end

			amount = item:NumClamp(amount)

			placeVoxel(region, item, amount)

			db_next[player.UserId] = tick() + (amount * 2) - 0.5 -- In case of lag up to 500 ms

			return true
		end
	end
end
