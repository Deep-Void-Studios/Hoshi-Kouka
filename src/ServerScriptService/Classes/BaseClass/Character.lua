local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local Character = BaseClass:__MakeClass("Character")

function Character:ChildAdded(object)
	self[object.__ClassName] = object
end

return Character
