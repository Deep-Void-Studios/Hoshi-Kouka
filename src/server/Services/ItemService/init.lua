local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local ItemService = Knit.CreateService({
	Name = "ItemService",

	Client = {},
})

local dir = workspace.Objects.Items
local items = game:GetService("ServerStorage").Items
local models = game:GetService("ServerStorage").Models
local debris = game:GetService("Debris")

function ItemService:GetModel(item)
	local model = models:FindFirstChild(item.Name)

	assert(model, "Model not found for " .. item.Name)

	return model
end

function ItemService:GetItem(name)
	local item = require(items[name])

	item = item:Clone()

	return item
end

function ItemService:Spawn(item, cframe: CFrame, persist: boolean?)
	-- Copy to avoid breaking things
	item = item:Clone()
	-- Get item's model
	local model = ItemService:GetModel(item):Clone()
	model:PivotTo(cframe)
	model.Parent = dir

	-- If item should not persist then destroy in 10 minutes.
	if not persist then
		debris:AddItem(model, 600)
	end

	-- Set item's data
	local data = script.BaseModule:Clone()
	data.Name = "ItemData"
	data.Parent = model
	local mod = require(data)

	for i, v in pairs(item) do
		mod[i] = v
	end

	return model
end

function ItemService:Remove(model)
	model:Destroy()
end

return ItemService
