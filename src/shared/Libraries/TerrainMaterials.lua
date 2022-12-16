local Knit = require(game.ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local ClientComm
local RunService = game:GetService("RunService")

local equipment

if RunService:IsClient() then
	ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")
	local _, id = DataManager:Get(game:GetService("Players").LocalPlayer):await()

	local data = ClientComm:GetProperty(id)

	if not data:IsReady() then
		data:OnReady():await()
	end

	equipment = ClientComm:GetProperty(data:Get().Equipment)

	if not equipment:IsReady() then
		equipment:OnReady():await()
	end
end

local TerrainMaterials = {}

TerrainMaterials.__index = TerrainMaterials

TerrainMaterials.Materials = {}

local raw = {
	Grass = { 0.5, 0, "Shovel" },
	Ground = { 0.4, 0, "Shovel" },
	Sand = { 0.4, 0, "Shovel" },
	Rock = { 1, 1, "Pickaxe" },
	Slate = { 2, 2, "Pickaxe" },
	Limestone = { 4, 3, "Pickaxe" },
	Basalt = { 16, 999, "Pickaxe" },
}

function TerrainMaterials:GetDamage(player)
	assert(player, "No player given.")

	local tool

	if RunService:IsClient() then
		tool = equipment:Get()[self.Tool]

		if tool then
			tool = ClientComm:GetProperty(tool)

			if not tool:IsReady() then
				tool:OnReady():await()
			end

			tool = tool:Get()
		end
	else
		tool = DataManager:Get(player).Equipment[self.Tool]
	end

	if self.Tier <= 0 then
		-- Harvestable by hand
		if tool then
			return tool.Properties.MiningDamage / self.Hardness / 1000, true, tool.Properties.MiningDelay
		else
			return 50 / self.Hardness / 1000, true, 0.5
		end
	else
		if tool then
			local tier = tool.Properties.MiningTier

			if tier >= self.Tier then
				-- Harvest level for this material type is sufficient.
				return tool.Properties.MiningDamage / self.Hardness / 1000, true, tool.Properties.MiningDelay
			else
				-- Harvest level is too low.
				return tool.Properties.MiningDamage / self.Hardness / 10000, false, tool.Properties.MiningDelay
			end
		else
			-- No tool and Tier > 0.
			return 50 / self.Hardness / 10000, false, 0.5
		end
	end
end

function TerrainMaterials:GetMaterial(material)
	return self.Materials[material]
end

function TerrainMaterials:AddMaterial(material, hardness, tier, tool)
	local tmat = {}

	tmat.Name = material
	tmat.Material = Enum.Material[material]
	tmat.Hardness = hardness
	tmat.Tier = tier
	tmat.Tool = tool

	setmetatable(tmat, self)

	self.Materials[material] = tmat
end

for i, v in pairs(raw) do
	TerrainMaterials:AddMaterial(i, table.unpack(v))
end

return TerrainMaterials
