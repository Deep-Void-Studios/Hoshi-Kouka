local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local chatGui = playerGui:WaitForChild("Chat")
local chat: Frame = chatGui:WaitForChild("Frame")

local chatFrame1: Frame = chat:WaitForChild("ChannelsBarParentFrame")
local chatFrame2: Frame = chat:WaitForChild("ChatBarParentFrame")
local chatFrame3: Frame = chat:WaitForChild("ChatChannelParentFrame")

local function update()
	local offset = chatFrame1.AbsoluteSize.Y + chatFrame2.AbsoluteSize.Y + chatFrame3.AbsoluteSize.Y

	print(offset)

	chat.Position = UDim2.new(0, 0, 1, -offset)
end

chatFrame1:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
chatFrame2:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
chatFrame3:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

update()
