local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local SS = game:GetService("ServerStorage")
local copy = require(RS.Libraries.HoshiUtils.DeepCopy)
local terrain = workspace.Terrain
local events = RS.Events.World.Terrain
local digEvent = events.Dig
local placeEvent = events.Place
-- Reach distance is 12, but an extra 2 is added in case of lag
local reachDistance = 12 + 2

local materials = require(RS.TerrainMaterials)

local offset = Vector3.new(2,2,2)

local function getRegion(pos)
	return Region3.new(pos-offset, pos+offset)
end

local function getVoxel(region)
	local materials, occupancies = terrain:ReadVoxels(region, 4)
	
	return materials[1][1][1], occupancies[1][1][1]
end

local db_next = {}

local function debounce(player : Player)
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
	local item = SS.Items:FindFirstChild(material.Name)
	
	if not harvestable then item = nil end
	
	local mats = {{{material}}}
	local occs
	
	local removed
	
	if occupancy >= damage then
		occs = {{{occupancy - damage}}}
		removed = damage
	else
		occs = {{{0}}}
		removed = occupancy
	end
	
	if item then
		item = copy(require(item))
		item.Amount = removed
		
		local inventory = DataManager:Get(player).Inventory
		
		if not inventory:CanHold(item) then
			return false
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
			
			local material, occupancy = getVoxel(region)
			if material == Enum.Material.Air or material == Enum.Material.Water then return false end
			material = materials:GetMaterial(material)
			
			if material.Material == Enum.Material.Air then return false end
			
			local damage, harvestable, delay = material:GetDamage(player)
			
			db_next[player.UserId] = tick() + (delay - 0.5) -- In case of lag up to 500 ms
			
			local removed = damageVoxel(region, damage, harvestable, player)
			
			if removed then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

placeEvent.OnServerInvoke = function(player, pos, amount)
	
end
