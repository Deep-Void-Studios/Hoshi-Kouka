local PlayerGui = script.Parent
local chat = PlayerGui:WaitForChild("Chat", 60)
--ChatBarParentFrame - Frame
if chat then
	local frame : Frame = chat:WaitForChild("Frame")
	local chatbar = frame:WaitForChild("ChatBarParentFrame"):WaitForChild("Frame")
	
	
	
	chatbar.Changed:Connect(function(property)
		if property == "AbsoluteSize" then
			local defaultSize = chatbar.Parent.AbsoluteSize.Y
			local shift = -(frame.AbsoluteSize.Y + (chatbar.AbsoluteSize.Y - defaultSize))
			
			frame.Position = UDim2.new(0, 0, 1, shift)
		end
	end)
	
	frame.Position = UDim2.new(0, 0, 1, -frame.AbsoluteSize.Y)
else
	error("Chat not found.")
end
