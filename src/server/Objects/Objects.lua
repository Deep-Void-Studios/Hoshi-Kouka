local module = {}

local resources = game:GetService("ServerStorage").Models
local directory = game:GetService("Workspace").Objects

-- Remove model without dropping items.
module.remove = function(model)
	model:Destroy()
end

-- Place model.
module.place = function(obj, cframe)
	local object: Model = obj:Clone()

	object:PivotTo(cframe)

	if not directory:FindFirstChild(object:GetAttribute("Type")) then
		local folder = Instance.new("Folder")
		folder.Parent = directory
		folder.Name = object:GetAttribute("Type")
	end

	object.Parent = directory[object:GetAttribute("Type")]

	return object
end

local typegroups = {
	{ "SmallPlant", "Plant", "BigPlant", "Tree", "BigTree", "BeachTree" },
	{ "Rock" },
}

module.placeNC = function(obj, cframe)
	local object: Model = module.place(obj, cframe)

	local objectType = object:GetAttribute("Type")

	local params = OverlapParams.new()

	local toFilter = {}

	for _, group in pairs(typegroups) do
		for _, ty in pairs(group) do
			if ty == objectType then
				for _, v in pairs(group) do
					local folder = directory:FindFirstChild(v)

					if folder then
						table.insert(toFilter, folder)
					end
				end
			end
		end
	end

	params.FilterDescendantsInstances = toFilter
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local objCFrame, objSize = object:GetBoundingBox()

	-- If part is found, delete.
	if workspace:GetPartBoundsInBox(objCFrame, objSize, params)[1] then
		module.remove(object)
		return false
	end

	return object
end

-- Search multiple types in a table.
-- Return true if one of the types, return false if not.
local function multiTypeSearch(types, objType)
	for _, ty in pairs(types) do
		if objType == ty then
			return true
		end
	end

	return false
end

module.randomDecoration = function(types)
	local objects = {}

	for _, obj in pairs(resources:GetChildren()) do
		local objType = obj:GetAttribute("Type")

		if multiTypeSearch(types, objType) then
			table.insert(objects, obj)
		end
	end

	return objects[math.random(1, #objects)]
end

-- Remove model and drop item(s).
--[[ module.destroy = function(model)
	-- TODO
end]]

return module
