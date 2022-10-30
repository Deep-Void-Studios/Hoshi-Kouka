local conveyor = script.Parent

local attStart = conveyor:FindFirstChild("Back")
local attEnd = conveyor:FindFirstChild("Front")

local function setVelocity()
	local direction = attEnd.WorldPosition - attStart.WorldPosition

	local conveyorVelocity = direction.Unit * conveyor:GetAttribute("ConveyorSpeed")
	conveyor.AssemblyLinearVelocity = conveyorVelocity
end

conveyor:GetAttributeChangedSignal("ConveyorSpeed"):Connect(setVelocity)
conveyor:GetPropertyChangedSignal("Orientation"):Connect(setVelocity)
setVelocity()
