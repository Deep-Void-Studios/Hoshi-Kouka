local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

Knit.OnStart():await()

local MessageService = Knit.GetService("MessageService")

local function Run(ChatService)
	local channel = ChatService:GetChannel("Global")
	
	MessageService.SendSystemMessage:Connect(function(message)
		channel:SendSystemMessage(message)
	end)
end

return Run
