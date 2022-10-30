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

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local notify = Knit.CreateService {
	Name = "NotificationService"
}

local SFX = game:GetService("SoundService").SFX
local event = game:GetService("ReplicatedStorage").NotificationCards.RemoteEvent

local function fire(params, player)
	event:FireClient(player, "Notify", params)
end

function notify:Info(title, message, player, silent)
	local sound = SFX.Generic.notification1 and not silent
	
	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = sound
	}
	
	fire(params, player)
end

function notify:Warn(title, message, player, silent)
	local sound = SFX.Generic.error1 and not silent
	
	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = sound,
		Color = Color3.fromRGB(222, 135, 64)
	}

	fire(params, player)
end

function notify:Error(title, message, player, silent)
	local sound = SFX.Generic.error2 and not silent
	
	local params = {
		Name = "Info",
		Title = title,
		Body = message,
		Sound = sound,
		Color = Color3.fromRGB(195, 59, 59)
	}
	
	fire(params, player)
end

return notify
