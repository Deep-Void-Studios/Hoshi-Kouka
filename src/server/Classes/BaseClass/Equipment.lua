local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local DataManager

local BaseClass = require(script.Parent)

local Equipment = BaseClass:__MakeClass("Equipment")

function Equipment:KnitStart()
	DataManager = Knit.GetService("DataManager")
end

local function findTool(slot, player)
	local char = player.Character

	if not char then
		warn("No character.")
		return
	end

	local tool = char:FindFirstChild(slot) or player.Backpack:FindFirstChild(slot)

	return tool
end

local function removeToolOnDeath(player: Player, tool)
	local char = player.Character
	local backpack = player.Backpack

	if char then
		if not tool then
			return
		end

		local humanoid = char:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			if tool.Parent ~= backpack then
				tool.Parent = backpack
			end
		end)
	end

	player.CharacterAdded:Connect(function(character)
		if not tool then
			return
		end

		local humanoid = character:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			if tool.Parent ~= backpack then
				tool.Parent = backpack
			end
		end)
	end)
end

local I2T = require(game:GetService("ServerScriptService").Objects.ItemToTool)

function Equipment:__AddTool(slot)
	assert(self.Player, "No player found.")

	local tool = I2T.makeTool(self[slot])
	local player = self.Player
	local backpack = player.Backpack

	tool.Name = slot
	tool.Parent = backpack

	removeToolOnDeath(player, tool)
end

function Equipment:__RemoveTool(slot)
	assert(self.Player, "No player found.")

	local tool = findTool(slot, self.Player)

	if tool then
		tool:Destroy()
	end
end

function Equipment:ChildAdded(child, slot)
	assert(slot, "Slot must be used when equipping to Equipment.")
	assert(child, "Child not found.")
	assert(child.__ClassName == "Item", "Child must be of type: Item, received " .. child.__ClassName .. ".")

	local previous = self[slot]

	if previous then
		assert(self.Player, "No player found.")

		local inv = DataManager:Get(self.Player).Inventory

		previous:SetParent(inv)
	end

	self[slot] = child

	child.Index = slot

	self.Updated:Fire()

	if self.Player then
		self:__AddTool(slot)
	else
		local signal

		signal = self.Updated:Connect(function()
			if self.Player then
				self:__AddTool(slot)

				signal:Disconnect()
			end
		end)
	end
end

function Equipment:ChildRemoved(slot)
	self:__RemoveTool(slot)

	self[slot] = nil
	self.Updated:Fire()
end

return Equipment
