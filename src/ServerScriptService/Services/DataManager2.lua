-- Knit
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local DataManager = Knit.CreateService({Name = "DataManager", Client = {}})

-- Services and Classes
local Character
local Status
local Equipment
local LevelTable
local Level
local Inventory
local Item

-- Other Services
local players = game:GetService("Players")
local ProfileService = require(script.Parent.Parent.ProfileService)

-- Variables
local profiles = {}
local ProfileStore

DataManager.ProfileLoaded = Signal.new()

function DataManager:KnitStart()
	Character = Knit.GetService("Character")
	
	Status = Knit.GetService("Status")
	Equipment = Knit.GetService("Equipment")
	LevelTable = Knit.GetService("LevelTable")
	Level = Knit.GetService("Level")
	Inventory = Knit.GetService("Inventory")
	Item = Knit.GetService("Item")
end

function DataManager:Get(player : Player, skipYield : boolean?)
	if not ProfileStore then
		ProfileStore = ProfileService.GetProfileStore("PlayerData", Character:New())
	end
	-- Get profile
	local id = player.UserId
	local profile = profiles["Player_"..id]

	-- Check if not found
	if profile then
		-- If found, return profile
		return profile.Character

	elseif not skipYield then
		-- Wait until profile is found.
		while true do
			-- Wait until SetupComplete signal is fired and check if it belongs to this player.
			if DataManager.ProfileLoaded:Wait() == player then
				break
			end
		end

		profile = profiles["Player_"..id]

		-- Return profile when available
		return profile.Character
	end
end

function DataManager.Client:Get(...)
	local data = self.Server:Get(...)
	
	return data.Id
end

local function deserialize(data, player)
	local character = Character:New()
	character:SetPlayer(player)
	
	-- Load status
	local status = Status:New(data.Status)
	status:SetParent(character)
	
	-- Load levels
	local levels = LevelTable:Make()
	levels:SetParent(character)
	
	for group, v in pairs(data.LevelTable) do
		for name, level in pairs(v) do
			if group == "Base" then
				data.LevelTable[group][name] = Level:NewBase(level)
				
			else
				data.LevelTable[group][name] = Level:New(level)
			end
		end
	end
	
	-- Load equipment
	local equipment = Equipment:New()
	equipment:SetParent(character)
	
	for i, v in pairs(data.Equipment) do
		equipment[i] = Item:New(v)
	end
	
	-- Load inventory
	local inventory = Inventory:New()
	inventory:SetParent(character)
	
	for i, v in ipairs(data.Inventory) do
		if type(v) == "table" then
			inventory[i] = Item:New(v)
		else
			inventory[i] = v
		end
	end
	
	return character
end

local function SetupProfile(player)
	if not ProfileStore then
		ProfileStore = ProfileService.GetProfileStore("PlayerData", Character:New())
	end
	-- Load profile
	-- "ForceLoad" = Kick any other server accessing this data.
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

	if profile then
		-- Associate player with profile
		-- (Mainly for legal reasons)
		profile:AddUserId(player.UserId)

		profile.Data = deserialize(profile.Data)

		-- Function for when the profile is released (unloaded)
		profile:ListenToRelease(function()
			local id = "Player_"..player.UserId

			profiles[id] = nil
			player:Kick()
		end)

		-- Loading data may take a moment
		-- so check if the player is still here
		if player:IsDescendantOf(players) then
			-- Set up profile to add to the profile list
			local player_profile = {
				-- Allow the profile to be accessed
				Profile = profile,
				-- Set up data
				Character = profile.Data,
				-- Easily get player
				_player = player,
			}

			-- Put the profile in the table
			profiles["Player_"..player.UserId] = player_profile
			
			DataManager.ProfileLoaded:Fire(player)
		else
			-- Remove from server memory if player has left
			profile:Release()
		end
	else
		-- An error has occurred, remove
		-- player to prevent data loss
		player:Kick("Loading Error; Contact developers at https://guilded.gg/hoshi-kouka if the issue persists.") 
	end
end

-- Load player data
players.PlayerAdded:Connect(function(player)
	-- Set up profile
	Knit.OnStart():await()
	SetupProfile(player)
end)

-- Remove from server memory when leaving
players.PlayerRemoving:Connect(function(player)
	local id = player.UserId
	local profile = profiles["Player_"..id]

	if profile then
		profile.Profile:Release()
	end
end)

return DataManager