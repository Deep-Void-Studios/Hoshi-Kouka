local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local TerrainMaterial = {}
local HoshiUtils = require(game.ReplicatedStorage.Libraries.HoshiUtils)
local pathfind = HoshiUtils.Pathfind
local RunService = game:GetService("RunService")
local DataManager

type path = {[number] : string}

function TerrainMaterial:KnitStart()
	DataManager = Knit.GetService("DataManager")
end

function TerrainMaterial:New(material : Enum.Material, hardness : number, tier : number, ty : path)
	assert(material, "Argument 1 missing or nil.")
	assert(hardness, "Argument 2 missing or nil.")
	assert(tier, "Argument 3 missing or nil.")
	assert(ty, "Argument 4 missing or nil.")
	
	local mat = {
		Name = material.Name,
		Material = material,
		Hardness = hardness,
		Tier = tier,
		Tool = ty,
		
		__Class = TerrainMaterial,
		__ClassName = "TerrainMaterial"
	}
	
	setmetatable(mat, self)
	
	self.__index = self
	
	return mat
end

function TerrainMaterial:GetDamage(player : Player)
	assert(player, "No player given.")
	
	local equipment = DataManager:Get(player).Equipment
	
	local tool = pathfind(equipment, self.Tool)
	
	if self.Tier <= 0 then
		-- Harvestable by hand
		if tool then
			return tool.Properties.Tool.Damage / self.Hardness / 1000, true, tool.Properties.Tool.Delay
		else
			return 50 / self.Hardness / 1000, true, 0.5
		end
	else
		if tool then
			local tier = tool.Properties.Tool.Tier
			
			if tier >= self.Tier then
				-- Harvest level for this material type is sufficient.
				return tool.Properties.Tool.Damage / self.Hardness / 1000, true, tool.Properties.Tool.Delay
			else
				-- Harvest level is too low.
				return tool.Properties.Tool.Damage / self.Hardness / 10000, false, tool.Properties.Tool.Delay
			end
		else
			-- No tool and Tier > 0.
			return 50 / self.Hardness / 10000, false, 0.5
		end
	end
end

return TerrainMaterial
