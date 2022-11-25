local module = {}

local Sound = require(script.Parent.Sounds)
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local tweenTime = 0.2
local animating = {}

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

function getEnd(gui, ty)
	local transparency = gui:GetAttribute(ty)

	local endInfo = {}

	endInfo[ty] = transparency

	if ty == "TextTransparency" then
		endInfo.TextStrokeTransparency = transparency
	end

	return endInfo
end

module.makeOpaque = function(gui)
	gui.Enabled = true

	for _, v in pairs(gui:GetDescendants()) do
		if isGui(v) and v:GetAttribute("BackgroundTransparency") then
			local endInfo = getEnd(v, "BackgroundTransparency")

			TS:Create(v, baseInfo, endInfo):Play()

			if hasImage(v) then
				local eInfo = getEnd(v, "ImageTransparency")

				TS:Create(v, baseInfo, eInfo):Play()
			elseif hasText(v) then
				local eInfo = getEnd(v, "TextTransparency")

				TS:Create(v, baseInfo, eInfo):Play()
			end
		end
	end
end

module.makeTransparent = function(gui)
	for _, v in pairs(gui:GetDescendants()) do
		if isGui(v) then
			local init = false

			if not v:GetAttribute("BackgroundTransparency") then
				init = true
				v:SetAttribute("BackgroundTransparency", v.BackgroundTransparency)
			end

			TS:Create(v, baseInfo, fadeOut):Play()
			if hasImage(v) then
				if init then
					v:SetAttribute("ImageTransparency", v.ImageTransparency)
				end

				-- Fade image transparency
				TS:Create(v, baseInfo, imageOut):Play()
			elseif hasText(v) then
				if init then
					v:SetAttribute("TextTransparency", v.TextTransparency)
				end

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
