-- Notification feed UI, by plasma_node
-- v 0.1

-- There are two main types of card notifications:
-- DECAYING CARDS: Automatically disappear after a set time
-- PERSISTENT CARDS: Do not clear unless manually cleared

---=== REQUIREMENTS ===---


local UI = script.Parent;
local Tray = UI.Container.Tray.Content;
local Scroll = Tray.ScrollingFrame;
local Main = game.ReplicatedStorage:FindFirstChild("NotificationCards");
--print("<NotificationCards, by Plasma_Node, Version `"..Main.VERSION.Value.."`>")

local Cards = Main.Cards;

local Event = Main.Event;
local RemoteEvent = Main.RemoteEvent;

---=== ------------- ===---
local Player = game.Players.LocalPlayer;

local R = Random.new(os.clock() * os.time());
local TS = game.TweenService;

local RS = game:GetService("RunService").RenderStepped;

local Hovering = false;
local Enabled = true; -- False = do not respond to any requests
local Hidden = false; -- Is UI hidden

local Count = 0;
local PermanentCount = 0;

--[[
local Config = {
	
	Muted = false; -- Set to true to mute all sounds
	AnimateIn = true; 
	AnimationDirection = "Left"; -- Right or Left. Left for right side of screen, vice versa
	
	Height = UDim.new(0.65, 0);
	
	InTime = 0.5; -- Defaults
	Lifetime = 5; -- Defaults
	OutTime = 2; -- Defaults
	
	Padding = 25; -- Pixels
};
--]]

local Config = require(Main.DefaultConfig);



Config.FadeInfo = TweenInfo.new(
	Config.OutTime,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
);



---=== ------------- ===---

function FindCard (Name)
	local attempt = Cards:FindFirstChild(Name);
	if (attempt) then
		return attempt;
	end
	error ("[NotificationUI] Could not find a card named `"..Name.."`!", 0);
	return false;
end

function UpdatePersistentCount ()
	local i = 0;
	for _, card in pairs (Scroll:GetChildren()) do
		if (card:IsA("UIListLayout") and not card:GetAttribute("Persistent")) then
			continue;
		end
		i += 1;
	end
	Count = i;
end

function UpdateCount ()
	local i = 0;
	for _, card in pairs (Scroll:GetChildren()) do
		if (card:IsA("UIListLayout")) then
			continue;
		end
		i += 1;
	end
	Count = i;
end



function Clear (ExcludePersistentCards) -- Clears all active notifications
	if (not ExcludePersistentCards) then
		for i, card in pairs (Scroll:GetChildren()) do
			if (card:IsA("UIListLayout")) then
				continue;
			end
			task.spawn(function () FadeOut(card, 0.5, true); end);
			if (Count < 10) then
				wait(0.06);
			elseif (Count < 60) then
				RS:Wait();
			end
			--card:Destroy();
		end
	else
		for i, card in pairs (Scroll:GetChildren()) do
			if (card:IsA("UIListLayout") or card:GetAttribute("Persistent")) then
				continue;
			end
			if (Count < 10) then
				wait(0.06);
			elseif (Count < 60) then
				RS:Wait();
			end
			task.spawn(function () FadeOut(card, 0.5, true); end);
			--card:Destroy();
		end
	end
	UpdateCount();
end

function UpdateConfig () -- Runs when the config has updated to change things as needed
	
	--Scroll.Size = UDim2.new(1, 0, Config.Height.Scale, Config.Height.Offset);
	TS:Create(Scroll, TweenInfo.new(
			1,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{ Size = UDim2.new(1, 0, Config.Height.Scale, Config.Height.Offset); }
	):Play();
	
	
	Config.FadeInfo = TweenInfo.new(
		Config.OutTime,
		Config.FadeInfo.EasingStyle,
		Config.FadeInfo.EasingDirection
	);
	
	Scroll.UIListLayout.Padding = UDim.new(0, Config.Padding);
	
end

---=== ------------- ===---

function PlaySound (Sound, V)
	if (Config.Muted) then
		return false;
	end
	task.spawn(function ()
		local s = Sound:Clone();
		
		s.Parent = workspace:FindFirstChild("PlayingSounds") or workspace;

		local v = V or 0; --or 0.15;

		s.PlaybackSpeed += R:NextNumber(-v, v);
		s:Play();
		wait(s.TimeLength);
		s:Destroy();
	end);
end

function PlaySoundId (Id, V, DontClone)
	if (Config.Muted) then
		return false;
	end
	task.spawn(function ()
		local s = Instance.new("Sound");
		s.SoundId = Id;
		s.Parent = workspace:FindFirstChild("PlayingSounds") or workspace;

		local v = V or 0; --or 0.15;

		s.PlaybackSpeed += R:NextNumber(-v, v);
		s:Play();
		wait(s.TimeLength);
		s:Destroy();
	end);
end


function FadeOut (Card, Time, Destroy)
	local info;
	if (Time) then
		info = TweenInfo.new(
			Time,
			Config.FadeInfo.EasingStyle,
			Config.FadeInfo.EasingDirection
		);
	else
		info = Config.FadeInfo;
	end
	
	for i, o in pairs(Card:GetDescendants()) do
		if (o.ClassName == "Frame" or o.ClassName == "ScrollingFrame") then
			TS:Create(o, info, {BackgroundTransparency = 1}):Play();
		elseif (o.ClassName == "ImageLabel" or o.ClassName == "ImageButton") then
			TS:Create(o, info, {BackgroundTransparency = 1}):Play();
			TS:Create(o, info, {ImageTransparency = 1}):Play();
		elseif (o.ClassName == "TextLabel" or o.ClassName == "TextButton" or o.ClassName == "TextBox") then
			TS:Create(o, info, {BackgroundTransparency = 1}):Play();
			TS:Create(o, info, {TextTransparency = 1}):Play();
			TS:Create(o, info, {TextStrokeTransparency = 1}):Play();
		end
	end
	
	if (Destroy) then
		task.wait(Time);
		Card:Destroy();
	end
end

---=== ------------- ===---

function Add (Info)
	task.spawn(function () 
		local card = Info.Card;
		card.Visible = true;
		card.Parent = Scroll;
		
		
		
		if (Info.Id) then
			card:SetAttribute("Id", Info.Id);
		else
			card:SetAttribute("Id", 0);
		end
		
		if (Info.Sound) then
			local vary = 0;
			local sound = Info.Sound;
			
			if (Info.SoundVary) then
				if (Info.SoundVary == true) then
					vary = 0.15;
				else
					vary = Info.SoundVary;
				end
			end
			
			if (typeof(sound) == "string") then
				if (string.find(sound, "rbxassetid://")) then
					PlaySoundId(sound, vary);
				else
					sound = Main.Sounds:FindFirstChild(sound);
					if (sound) then
						PlaySound(sound, vary)
					end
				end
			elseif (typeof(sound) == "Instance") then
				PlaySound (sound, vary);	
			end
		end
		
		if (Info.Script) then
			card.Script.Disabled = false;
		end
		
		if (not Info.DontAnimate and Config.AnimateIn) then
			
			if (Config.AnimationDirection == "Left") then -- Left to right
				card.Box.Position = UDim2.new(2, 0, 0, 0);
			elseif (Config.AnimationDirection == "Right") then -- Right to left
 				card.Box.Position = UDim2.new(-2, 0, 0, 0);
			end
			
			TS:Create(card.Box, TweenInfo.new(
				Config.InTime,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
				), { Position = UDim2.new(0,0,0,0)}):Play();
			
			wait(Config.InTime);

			
		end
		
		if (not Info.Persistent) then
			task.wait(Info.Lifetime)
			FadeOut (card, Config.OutTime);
			task.wait(Config.OutTime);
			card:Destroy();
			UpdateCount ();
		end
		
	end);
	UpdateCount();
end

function NewCard (Data)
	local card;
	
	if (typeof(Data) == "string") then
		card = FindCard(Data or "Notification");
	else
		card = FindCard(Data.Type or Data.Name or "Notification");
	end
	
	if (card) then
		card = card:Clone();
		
		local box = card.Box;
		
		if (Data.Title) then
			box.Title.Text = Data.Title;
		end
		
		if (Data.Body) then
			box.Body.Text = Data.Body;
		end
		
		if (Data.Weight) then
			card.LayoutOrder = Data.Weight;
		end
		
		if (box:FindFirstChild("Button")) then
			if (Data.OnClick) then
				box.Button.MouseButton1Click:Connect(Data.OnClick);
			end
			if (Data.OnHover) then
				box.Button.MouseButton1Click:Connect(Data.OnHover);
			end
			if (Data.OnLeave) then
				box.Button.MouseButton1Click:Connect(Data.OnLeave);
			end
		end
		
		
		if (Data.Color) then
			box.TitleBar.BackgroundColor3 = Data.Color;
			if (box.TitleBar:FindFirstChild("Anticorner")) then
				box.TitleBar.Anticorner.BackgroundColor3 = Data.Color;
			end
			
			if (box.IconFrame:FindFirstChild("TextLabel")) then
				box.IconFrame.TextLabel.TextColor3 = Data.Color;
			end
		end
		
		if (Data.IconText) then
			if (box.IconFrame:FindFirstChild("TextLabel")) then
				box.IconFrame.TextLabel.Text = Data.IconText;
			end
		end
		
		if (Data.BackgroundColor) then
			box.Background.BackgroundColor3 = Data.BackgroundColor;
		end
		
		if (Data.Icon) then
			box.IconFrame.ImageLabel.Visible = true;
			box.IconFrame.ImageLabel.Image = Data.Icon;
			if (box.IconFrame:FindFirstChild("TextLabel")) then
				box.IconFrame.TextLabel.Visible = false;
			end
		end
		
		if (Data.Persist) then
			card:SetAttribute("Persist", true);
			Data.Lifetime = 0;
		end
		
		if (Data.Clearable) then
			if (box:FindFirstChild("ClearButton")) then
				box.ClearButton.MouseButton1Click:Connect(function ()
					FadeOut(card, 0.5, true);
					UpdateCount();
				end);
			end
		end
		
		Add({
			Lifetime = Data.Lifetime or Config.Lifetime;
			Persistent = Data.Persistent or false;
			Sound = Data.Sound or false;
			SoundVary = Data.SoundVary or false;
			Card = card;
			Script = Data.Script or false;
			Id = Data.Id or false;
		});
	end
end

---=== ------------- ===---

-- Adjust the scrollbox when new content gets added

Scroll.MouseEnter:Connect(function ()
	Hovering = true;
end)

Scroll.MouseLeave:Connect(function ()
	Hovering = false;
end)

Scroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	if (Hovering == true) then
		local absoluteContentSize = Scroll.UIListLayout.AbsoluteContentSize
		Scroll.CanvasPosition = Vector2.new(0, absoluteContentSize.Y);
	end
end)

game["Run Service"]:BindToRenderStep("Adjust", Enum.RenderPriority.Last.Value, function ()
	if (Hovering == false) then 
		local absoluteContentSize = Scroll.UIListLayout.AbsoluteContentSize
		Scroll.CanvasPosition = Vector2.new(0, absoluteContentSize.Y);
	end
end)
--[[
task.spawn(function ()
	while true do
		RS:Wait(); 
		if (Hovering == false) then 
			local absoluteContentSize = Scroll.UIListLayout.AbsoluteContentSize
			Scroll.CanvasPosition = Vector2.new(0, absoluteContentSize.Y);
		end

	end
end)
--]]

---=== ------------- ===---

function HandleEvent (Request, Data)
	if (Request == "Notify") then
		if (Enabled) then
			NewCard(Data);
		end
	elseif (Request == "Alert") then
		if (Enabled) then
			
		end
	elseif (Request == "Disable") then
		
	elseif (Request == "Enable") then
		
	elseif (Request == "Hide") then
		Hidden = true;
		Tray.Visible = false;
	elseif (Request == "Show") then
		Hidden = false;
		Tray.Visible = true;
	elseif (Request == "Configure") then
		for i, n in pairs(Data) do
			Config[i] = n;
		end
		
		UpdateConfig();
	elseif (Request == "GetConfig") then
		return Config;
	elseif (Request == "Clear") then
		if (not Data or Data == "All") then
			Clear();
		elseif (Data == "Decaying" or Data == "ExcludePersistent") then
			-- Clear only cards that have a timeout, and not ones that stay until dismissed
			Clear(true)
		end
	end
end

Event.Event:Connect(HandleEvent);
RemoteEvent.OnClientEvent:Connect(HandleEvent);

if (not workspace:FindFirstChild("PlayingSounds")) then
	local f = Instance.new("Folder");
	f.Name = "PlayingSounds";
	f.Parent = workspace;
end

UpdateConfig();