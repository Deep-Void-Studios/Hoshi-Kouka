local character = script.Parent
local terrain = workspace.Terrain
local offset = Vector3.new(2, 2, 2)

local function getVoxel(root)
	local pos = root.Position
	local center = terrain:WorldToCell(pos)
	pos = terrain:CellCenterToWorld(center.X, center.Y, center.Z)

	local region = Region3.new(pos - offset, pos + offset)

	local materials, occupancies = terrain:ReadVoxels(region, 4)

	return materials[1][1][1], occupancies[1][1][1]
end

local lastCFrame

while character.Parent and task.wait(0.2) do
	if character:FindFirstChild("HumanoidRootPart") then
		local root = character.HumanoidRootPart

		local material, occupancy = getVoxel(root)

		if material == Enum.Material.Air then
			lastCFrame = root.CFrame
			continue
		end

		if occupancy < 1 then
			lastCFrame = root.CFrame
			continue
		else
			print("Player clipped into the ground! Rewinding...")
			character:PivotTo(lastCFrame)
		end
	end
end
