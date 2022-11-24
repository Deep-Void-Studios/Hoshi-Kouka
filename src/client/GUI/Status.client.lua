local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ClientComm = require(Knit.Util.Comm).ClientComm.new(game:GetService("ReplicatedStorage").Comm, false, "ClassComm")

Knit.OnStart():await()

local DataManager = Knit.GetService("DataManager")
local _, data = DataManager:Get(game:GetService("Players").LocalPlayer):await()
data = ClientComm:GetProperty(data)

data:OnReady():await()

local status = ClientComm:GetProperty(data:Get().Status)
local vitals = status:Get().Vitals

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui:WaitForChild("Status"):WaitForChild("base")

local bars = {
	gui.Health,
	gui.Hunger,
	gui.Mana,
	gui.Stamina,
}

local function setBar(bar, value, max)
	local fill = bar.fill
	local overfill = bar.overfill

	local fullness = value / max

	local size = UDim2.new(math.clamp(fullness, 0, 1), 0, 1, 0)
	local sizeOverfill = UDim2.new(math.clamp(fullness - 1, 0, 1), 0, 1, 0)

	fill.Size = size
	overfill.Size = sizeOverfill
end

for _, bar in pairs(bars) do
	local name = bar.Name

	setBar(bar, vitals[name], vitals["Max" .. name])
end
