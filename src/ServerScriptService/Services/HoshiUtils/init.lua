local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local HoshiUtils = Knit.CreateService {
	Name = "HoshiUtils"
}

for i, v in pairs(script:GetDescendants()) do
	HoshiUtils[v.Name] = require(v)
end

return HoshiUtils
