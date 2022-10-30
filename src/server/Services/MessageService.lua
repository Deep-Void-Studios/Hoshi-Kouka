local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local MessageService = Knit.CreateService {
	Name = "MessageService",
	
	Client = {}
}

MessageService.SendSystemMessage = Signal.new()

function MessageService:SystemMessage(message)
	MessageService.SendSystemMessage:Fire(message)
end

return MessageService
