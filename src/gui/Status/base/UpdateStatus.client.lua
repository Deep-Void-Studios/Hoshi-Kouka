local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local _, data = DataManager:Get(game:GetService("Players").LocalPlayer):await()
data = ClientComm:GetProperty(data):Get()
local status = ClientComm:GetProperty(data.Status)
local vitals = status:Get().Vitals

local RS = game:GetService("ReplicatedStorage")
local gui = script.Parent

local bars = {
	gui.Health,
	gui.Hunger,
	gui.Mana,
	gui.Stamina
}

local function setBar(bar, value, max)
	local fill = bar.fill
	local overfill = bar.overfill
	
	local fullness = value/max
	
	local size = UDim2.new(math.clamp(fullness, 0, 1), 0, 1, 0)
	local sizeOverfill = UDim2.new(math.clamp(fullness-1, 0, 1), 0, 1, 0)
	
	bar.fill.Size = size
	bar.overfill.Size = sizeOverfill
end

local function updateBar(bar, data)
	local name = bar.Name
	
	local value = data.Stats.Vitals[name]
	local max = data.Stats.Vitals["Max"..name]
		
	setBar(bar, value, max)
end

for _, bar in pairs(bars) do
	local name = bar.Name
	
	setBar(bar, vitals[name], vitals["Max"..name])
end