-- Knit
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local DataManager = Knit.CreateService({ Name = "DataManager", Client = {} })

-- Services and Classes
local Character

-- Other Services
local players = game:GetService("Players")
local ProfileService = require(script.Parent.Parent.ProfileService)

-- Variables
local profiles = {}
local ProfileStore

DataManager.ProfileLoaded = Signal.new()

function DataManager:KnitStart()
	Character = Knit.GetService("Character")
end

function DataManager:Get(player: Player, skipYield: boolean?)
	if not ProfileStore then
		ProfileStore = ProfileService.GetProfileStore("PlayerData", Character:New())
	end
	-- Get profile
	local id = player.UserId
	local profile = profiles["Player_" .. id]

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

		profile = profiles["Player_" .. id]

		-- Return profile when available
		return profile.Character
	end
end

function DataManager.Client:Get(...)
	local data = self.Server:Get(...)

	return data.Id
end

function DataManager:Reset(player)
	local id = "Player_" .. player.UserId
	local profile = profiles[id]

	profile.Character:Destroy()

	profile.Profile.Data = Character:New().__Serial

	player:Kick("Resetting data... Please rejoin.")
end

local function SetupProfile(player)
	if not ProfileStore then
		ProfileStore = ProfileService.GetProfileStore("PlayerData", Character:New().__Serial)
	end

	-- Load profile
	-- "ForceLoad" = Kick any other server accessing this data.
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

	print(profile.Data)

	local char = Character:Deserialize(profile.Data)
	profile.Data = char.__Serial

	print(char)

	if profile then
		-- Associate player with profile
		-- (Mainly for legal reasons)
		profile:AddUserId(player.UserId)

		-- Function for when the profile is released (unloaded)
		profile:ListenToRelease(function()
			local id = "Player_" .. player.UserId

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
				Character = char,
				-- Set up serial (this is what will be saved)
				Serial = profile.Data,
				-- Easily get player
				_player = player,
			}

			char.Updated:Connect(function()
				profile.Data = char.__Serial
				player_profile.Serial = profile.Data
			end)

			char.Updated:Fire()

			-- Put the profile in the table
			profiles["Player_" .. player.UserId] = player_profile

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
	local profile = profiles["Player_" .. id]

	print(profile.Character)

	if profile then
		profile.Profile:Release()
	end
end)

return DataManager
