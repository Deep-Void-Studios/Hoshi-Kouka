--[[
	Name = <String> (required) - The card template name
	Title = <String> - The card title
	Body = <String> - The card's message
	Sound = <String Name/String Id/Object> - The sound to play when the notification is sent
	Color = <Color3> - The primary color of the notification UI
	BackgroundColor = <Color3> - The background color of the notification UI
	Weight = <Number> - The importance of the card (higher = lower down)
	Icon = <String Id> - The card's icon
	IconText = <String> - Text in place of the icon (overriden by icon)
	Persist = <Boolean> - If true, persist until cleared
	Lifetime = <Number> - How long the card lasts before it fades.
	Clearable = <Boolean> - If true, will look for a button named ClearButton which must be above everything else.
	OnClick = <Function> - Function to execute on click.
	OnHover = <Function> - Function to execute on mouse hover.
	OnLeave = <Function> - Function to execute on mouse leave.
	Id = <String> - The ID, for getting certain cards.
--]]

local notify = {}

local RunService = game:GetService("RunService")
local SFX = game:GetService("SoundService").SFX
local isServer = RunService:IsServer()

local event

if isServer then
	event = game:GetService("ReplicatedStorage").Events.RemoteNotification
else
	event = game:GetService("ReplicatedStorage").Events.Notification.Event
end

local function fire(params, player)
	if isServer then
		event:FireClient(player, "Notify", params)
	else
		event:Fire("Notify", params)
	end
end

function notify:Info(title, message, player, silent)
	local sound = SFX.Generic.notification1 and not silent

	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = sound,
	}

	fire(params, player)
end

function notify:Warn(title, message, player)
	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = SFX.Generic.error1,
		Color = Color3.fromRGB(222, 135, 64),
	}

	fire(params, player)
end

function notify:Error(title, message, player)
	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = SFX.Generic.error2,
		Color = Color3.fromRGB(195, 59, 59),
	}

	fire(params, player)
end

return notify
