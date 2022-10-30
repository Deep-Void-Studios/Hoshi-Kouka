local module = {}
local SSS = game:GetService("ServerScriptService")
local dt = game.ReplicatedStorage.Datatypes
local itemLib = require(SSS.Objects.ItemService)

local function removePrompt(item:Model)
	for i, v:Instance in pairs(item:GetDescendants()) do
		if v.ClassName == "ProximityPrompt" then
			v:Destroy()
		end
	end
end

module.makeTool = function(item)
	local tool = Instance.new("Tool") tool.CanBeDropped = false
	local item : Model = itemLib:Spawn(item, CFrame.new(), true)
	item.Parent = tool
	
	local handleAttachment
	
	for i, v:Instance in pairs(item:GetDescendants()) do
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
		local handle = Instance.new("Part", tool)
		handle.Name = "Handle"
		handle:PivotTo(handleAttachment.WorldCFrame)
		handle.Transparency = 1
		handle.CanCollide = false
		handle.CanQuery = false
		handle.CanTouch = false
		handle.Size = Vector3.new(0.1, 0.1, 0.1)
		local weld = Instance.new("WeldConstraint", handle)
		weld.Part0 = handle
		weld.Part1 = handleAttachment.Parent
	else
		error("No Handle Found For "..item.Name..".")
	end
	
	return tool
end

return module
