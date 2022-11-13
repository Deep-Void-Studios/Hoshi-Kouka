local module = {}

local Sound = require(script.Parent.Sounds)
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local tweenTime = 0.2
local animating = {}
local guiOpacities = {}

local baseInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local fadeOut = {
	BackgroundTransparency = 1,
}

local imageOut = {
	ImageTransparency = 1,
}

local textOut = {
	TextTransparency = 1,
	TextStrokeTransparency = 1,
}

local function isGui(frame)
	if frame:IsA("GuiObject") then
		return true
	else
		return false
	end
end

local function hasImage(frame)
	if frame:IsA("ImageLabel") or frame:IsA("ImageButton") then
		return true
	else
		return false
	end
end

local function hasText(frame)
	if frame:IsA("TextLabel") or frame:IsA("TextButton") then
		return true
	else
		return false
	end
end

module.setup = function(gui)
	guiOpacities[gui.Name] = {}
	local defaultTransparency = guiOpacities[gui.Name]
	for i, v in pairs(gui:GetDescendants()) do
		if isGui(v) then
			v:SetAttribute("id", i)

			defaultTransparency[i] = v.BackgroundTransparency

			if hasImage(v) then
				v:SetAttribute("xid", -i)

				defaultTransparency[-i] = v.ImageTransparency
			elseif hasText(v) then
				v:SetAttribute("xid", -i)

				defaultTransparency[-i] = v.TextTransparency
			end
		end
	end
end

function getEnd(name, id, value)
	local transparency = guiOpacities[name][id]

	local endInfo = {}

	endInfo[value] = transparency

	if value == "TextTransparency" then
		endInfo["TextStrokeTransparency"] = transparency
	end

	return endInfo
end

module.makeOpaque = function(gui)
	gui.Enabled = true

	for _, v in pairs(gui:GetDescendants()) do
		if isGui(v) then
			local id = v:GetAttribute("id")
			local endInfo = getEnd(gui.Name, id, "BackgroundTransparency")

			TS:Create(v, baseInfo, endInfo):Play()

			if hasImage(v) then
				local xid = v:GetAttribute("xid")
				local eInfo = getEnd(gui.Name, xid, "ImageTransparency")

				TS:Create(v, baseInfo, eInfo):Play()
			elseif hasText(v) then
				local xid = v:GetAttribute("xid")
				local eInfo = getEnd(gui.Name, xid, "TextTransparency")

				TS:Create(v, baseInfo, eInfo):Play()
			end
		end
	end
end

module.makeTransparent = function(gui)
	for _, v in pairs(gui:GetDescendants()) do
		if isGui(v) then
			TS:Create(v, baseInfo, fadeOut):Play()
			if hasImage(v) then
				-- Fade image transparency
				TS:Create(v, baseInfo, imageOut):Play()
			elseif hasText(v) then
				-- Fade text transparency
				TS:Create(v, baseInfo, textOut):Play()
			end
		end
	end
end

local blacklist = {}

function module:Blacklist(gui)
	blacklist[gui.Name] = true
end

function module:RemoveBlacklist(gui)
	blacklist[gui.Name] = false
end

module.toggle = function(gui)
	if blacklist[gui.Name] then
		Sound:Play({ "Generic", "error2" })
		return false
	end

	if gui.Enabled then
		module.makeTransparent(gui)
		wait(tweenTime)

		if not animating[gui] then
			gui.Enabled = false
		end
	else
		gui.Enabled = true
		animating[gui] = true
		module.makeOpaque(gui)
		animating[gui] = false
	end
end

local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui
local cover = PlayerGui:WaitForChild("Cover", 30)

if not cover then
	error("Missing cover GUI.")
end

local function enableCursor()
	cover.Enabled = true
end

local function disableCursor()
	cover.Enabled = false
end

for _, gui: ScreenGui in pairs(PlayerGui:GetChildren()) do
	if gui:GetAttribute("ShowMouse") then
		gui.Changed:Connect(function()
			local showMouse = false

			for _, ui in pairs(PlayerGui:GetChildren()) do
				if ui:GetAttribute("ShowMouse") then
					if ui.Enabled then
						showMouse = true
						break
					end
				end
			end

			if showMouse then
				enableCursor()
			else
				disableCursor()
			end
		end)
	end
end

UIS.InputBegan:Connect(function(input, ignored)
	if input.KeyCode == Enum.KeyCode.LeftAlt and not ignored then
		enableCursor()
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftAlt then
		disableCursor()
	end
end)

return module
