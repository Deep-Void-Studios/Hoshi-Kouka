local RS = game:GetService("ReplicatedStorage")
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local menus = player.PlayerGui:WaitForChild("Menu", 30)
local main = menus:WaitForChild("main")
local assets = RS.ClientAssets.GUI
local buttonTemp = assets.ContextButton
local subTemp = assets.ContextMenu

if not menus then
	error("Menu not found.")
end
--local menuEntered = false

local subs = { [0] = main }

-- Erase menu and lower subs
local function clean(num)
	local menu = subs[num]

	if menu then
		for _, obj in pairs(menu:GetChildren()) do
			if obj.ClassName == "TextButton" then
				obj:Destroy()
			end
		end

		if menu ~= main then
			menu:Destroy()
		else
			menu.Visible = false
		end
	end

	if subs[num + 1] then
		clean(num + 1)
	end
end

-- Create the template menu to add on to
local function makeMenu(sub)
	-- Define menu variable
	local menu: Frame

	if sub == 0 then
		menu = main
	else
		menu = subTemp:Clone()
		subs[sub] = menu
		menu.Parent = menus
	end

	menu.MouseLeave:Connect(function()
		if subs[sub] == subs[#subs] then
			clean(0)
		end
	end)

	return menu
end

local function getType(action)
	if action.Subcategory then
		return "Subcategory"
	else
		return "Function"
	end
end

local function processParams(params, vars)
	for i, v in pairs(params) do
		if vars[v] then
			params[i] = vars[v]
		end
	end

	return params
end

local ContextMenu = Knit.CreateController({ Name = "ContextMenu" })

function ContextMenu:Close()
	clean(0)
end

function ContextMenu:Open(actions, set, sub: number, info)
	-- Clear previous menus
	clean(0)
	local menu = makeMenu(sub)

	-- Set menu
	menu.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
	menu.Visible = true

	if not actions then
		actions = {}
	end

	-- Loop through all actions
	for i, action in pairs(set) do
		if i == "KnitStart" or i == "Name" then
			continue
		end

		if action.AlwaysOn or actions[i] then
			-- Get action type (Function or Subcategory)
			local type = getType(action)
			-- Create button
			local button = buttonTemp:Clone()
			button.Name = action.Name
			button.Text = action.Name
			button.Parent = menu
			button.LayoutOrder = action.Place

			if type ~= "Subcategory" then
				button.Arrow.ImageTransparency = 1
			end

			button.Activated:Connect(function()
				if type == "Function" then
					-- Get function
					local func = action.Action[1]

					-- Get parameters
					local params = processParams(table.clone(action.Action[2]), info)

					-- Run function
					func(table.unpack(params))
					clean(0)
				else
					-- Get action subcategory
					local acts = actions[i]
					-- Get set subcategory
					local setsub = action.Subcategory
					-- Open a lower menu
					sub += 1
					-- Open subcategory
					ContextMenu:Open(acts, setsub, sub, info)
				end
			end)
		end
	end
end

return ContextMenu
