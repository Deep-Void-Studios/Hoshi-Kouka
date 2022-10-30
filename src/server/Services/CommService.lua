local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)
local ServerComm = require(Knit.Util.Comm).ServerComm

local dir = game:GetService("ReplicatedStorage").Comm

local CommService = Knit.CreateService {
	Name = "CommService",
	Client = {}
}

CommService.ClassComm = ServerComm.new(dir, "ClassComm")

function CommService:Get(name)
	return CommService[name]
end

return CommService
