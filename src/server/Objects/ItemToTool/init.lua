local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local I2T = Knit.CreateService({
	Name = "I2T",
	Client = {},
})

local ItemService

function I2T:KnitStart()
	ItemService = Knit.GetService("ItemService")
end

I2T.makeTool = function(item)
	local tool = Instance.new("Tool")
	tool.CanBeDropped = false
	item = ItemService:GetModel(item, CFrame.new(), true)
	item.Parent = tool

	local handleAttachment

	for _, v: Instance in pairs(item:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end

		if v:IsA("ProximityPrompt") then
			v:Destroy()
		end

		if v:IsA("Attachment") then
			if v.Name == "Handle" then
				handleAttachment = v
			end
		end
	end

	if handleAttachment then
		local handle = Instance.new("Part")
		handle.Parent = tool
		handle.Name = "Handle"
		handle:PivotTo(handleAttachment.WorldCFrame)
		handle.Transparency = 1
		handle.CanCollide = false
		handle.CanQuery = false
		handle.CanTouch = false
		handle.Size = Vector3.new(0.1, 0.1, 0.1)
		local weld = Instance.new("WeldConstraint")
		weld.Parent = handle
		weld.Part0 = handle
		weld.Part1 = handleAttachment.Parent
	else
		error("No Handle Found For " .. item.Name .. ".")
	end

	return tool
end

return I2T
