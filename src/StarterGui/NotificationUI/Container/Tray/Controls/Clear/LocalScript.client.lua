local Element = script.Parent;
local TS = game.TweenService;
local Button = Element.Button;

local hidden = true

local function Appear()
	local time1 = 0.3
	
	local info = TweenInfo.new(
		time1,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	)
	
	TS:Create(Element.UIScale, info, {Scale = 1}):Play()
	hidden = false
end

local function Fade()
	local time1 = 0.3

	local info = TweenInfo.new(
		time1,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	)
	
	TS:Create(Element.UIScale, info, {Scale = 0}):Play()
	hidden = true
end

local Hovering = false;

local function Hover ()
	local Time1 = 0.3;
	local Time2 = Time1/2;

	local Info1 = TweenInfo.new(
		Time1,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	);
	
	local Info2 = TweenInfo.new(
		Time2,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out
	);
	
	TS:Create(Element.UICorner, Info1, { CornerRadius = UDim.new(0,6) }):Play();
	--wait(0.1)
	TS:Create(Element.TextLabel, Info2, { TextTransparency = 0 }):Play();
	
end

local function UnHover ()
	local Time1 = 0.3;
	local Time2 = Time1/2;

	local Info1 = TweenInfo.new(
		Time1,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	);

	local Info2 = TweenInfo.new(
		Time2,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out
	);
	
	TS:Create(Element.TextLabel, Info2, { TextTransparency = 1 }):Play()
	
	--wait(0.1)
	TS:Create(Element.UICorner, Info1, { CornerRadius = UDim.new(1,0) }):Play();

end

Button.InputBegan:Connect(function (Input)
	if (Input.UserInputType == Enum.UserInputType.MouseButton1) then 
		game.ReplicatedStorage.NotificationCards.Event:Fire("Clear")
		
		if not hidden then
			Fade()
		end
		
		return
	end
	Hovering = true
	Hover ()
end)

Button.InputEnded:Connect(function (Input)
	if (Input.UserInputType == Enum.UserInputType.MouseButton1) then return; end
	Hovering = false;
	UnHover();
end)

local notifcards = game.ReplicatedStorage.NotificationCards
local latest

local function eventhandler(request)
	local id = time()
	
	if request == "Notify" or request == "Alert" then
		latest = id
		
		if hidden then
			Appear()
		end
	end
	
	wait(8)
	
	if latest == id then
		if not hidden then
			Fade()
		end
	end
end

notifcards.Event.Event:Connect(eventhandler)
notifcards.RemoteEvent.OnClientEvent:Connect(eventhandler)