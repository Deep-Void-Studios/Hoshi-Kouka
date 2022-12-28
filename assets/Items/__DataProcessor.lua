local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

Knit.OnStart():await()

local Item = Knit.GetService("Item")

local function processData(data)
	local item = Item:New()

	for i, v in pairs(data) do
		item[i] = v
	end

	return item
end

return { Process = processData }
