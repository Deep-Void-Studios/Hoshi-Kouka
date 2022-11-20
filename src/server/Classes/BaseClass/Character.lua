local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local BaseClass = require(script.Parent)
local Status
local Equipment
local Inventory
local LevelTable

local Character = BaseClass:__MakeClass("Character")

function Character:KnitStart()
	Status = Knit.GetService("Status")
	Equipment = Knit.GetService("Equipment")
	Inventory = Knit.GetService("Inventory")
	LevelTable = Knit.GetService("LevelTable")

	Character.__Defaults = {
		Status = Status:New(),
		Equipment = Equipment:New(),
		Inventory = Inventory:New(),
		LevelTable = LevelTable:New(),
	}
end

function Character:ChildAdded(object)
	self[object.__ClassName] = object
	object.Index = object.__ClassName
end

return Character
