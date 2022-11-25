-- Set dispenser
local dispenser = workspace.Spawn.Droppers.MultiDropper

-- Loop through children
for _, obj in pairs(dispenser:GetChildren()) do
	-- Check if conveyor
	if obj.Name == "Conveyor" then
		-- Set conveyor part
		local conveyor = obj.Conveyor

		-- Get front and back attachments
		local attStart = conveyor:FindFirstChild("Back")
		local attEnd = conveyor:FindFirstChild("Front")

		-- Define setVelocity function
		local function setVelocity()
			-- Get direction
			local direction = attEnd.WorldPosition - attStart.WorldPosition

			-- Calculate needed velocity
			local conveyorVelocity = direction.Unit * conveyor:GetAttribute("ConveyorSpeed")

			-- Set velocity
			conveyor.AssemblyLinearVelocity = conveyorVelocity
		end

		-- Connect setVelocity when changed
		conveyor:GetAttributeChangedSignal("ConveyorSpeed"):Connect(setVelocity)
		conveyor:GetPropertyChangedSignal("Orientation"):Connect(setVelocity)

		-- Initiate
		setVelocity()
	end
end
