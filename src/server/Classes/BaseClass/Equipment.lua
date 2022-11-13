-- local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local BaseClass = require(script.Parent)

local Equipment = BaseClass:__MakeClass("Equipment")

function Equipment:Equip(child, slot)
	self[slot] = child

	local signal = child.Updated:Connect(function()
		self.Updated:Fire()
	end)

	self[slot .. "Signal"] = signal

	self.Updated:Fire()
end

function Equipment:ChildRemoved(slot)
	self[slot] = nil
	self[slot .. "Signal"]:Disconnect()
	self.Updated:Fire()
end

return Equipment
