local distance = 1024

local Chat = game:GetService("Chat")
local ReplicatedModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ReplicatedModules:WaitForChild("ChatSettings"))

local function Run(ChatService)
	local Local = ChatService:AddChannel("Local")
	Local.AutoJoin = true
	
	local functionId = "LocalChat"
	
	local function proximity(player1 : Player, player2 : Player)
		local char1 = player1.Character
		local char2 = player2.Character
		
		if not (char1 and char2) then return false end
		
		local root1 = char1.HumanoidRootPart
		local root2 = char2.HumanoidRootPart
		
		if not (root1 and root2) then return false end
		
		if (root1.Position - root2.Position).Magnitude < distance then
			return true
		end
	end
	
	local function processLocal(speakerName, message, channelName)
		local speaker = ChatService:GetSpeaker(speakerName)
		local channel = ChatService:GetChannel(channelName)
		
		if not speaker then return false end
		if channel ~= Local then return false end
		
		local player = speaker:GetPlayer()
		
		if not player then return false end
		
		for _, otherSpeakerName in pairs(channel:GetSpeakerList()) do
			local otherSpeaker = ChatService:GetSpeaker(otherSpeakerName)
			
			if not otherSpeaker then continue end
			
			local otherPlayer = otherSpeaker:GetPlayer()
			
			if not otherPlayer then continue end
			
			if proximity(player, otherPlayer) then
				otherSpeaker:SendMessage(message, channelName, speakerName, message.ExtraData)
			end
		end
		
		return true
	end
	
	ChatService:RegisterProcessCommandsFunction(functionId, processLocal, ChatSettings.LowPriority)
end

return Run
