local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BaseClass = require(script.Parent)

local LevelTable = BaseClass:__MakeClass("LevelTable")

local level

LevelTable.Replicated = {
	Base = true,
	Skill = true,
	Weapon = true,
	Elements = true,
}

function LevelTable:KnitInit()
	level = Knit.GetService("Level")
end

local new = LevelTable.New

function LevelTable:New()
	local object = new(self, {
		Base = {
			Constitution = level:NewBase({
				Name = "Constitution",
				Description = "Increases health, defense, and XP gained for related levels.",
			}),

			Strength = level:NewBase({
				Name = "Strength",
				Description = "Increases melee damage and XP gained for related skills.",
			}),

			Stamina = level:NewBase({
				Name = "Stamina",
				Description = "Increases speed, max stamina, and XP gained for related skills.",
			}),

			Dexterity = level:NewBase({
				Name = "Dexterity",
				Description = "Increases accuracy, ranged damage, crafting quality, and XP gained for related skills.",
			}),

			Magic = level:NewBase({
				Name = "Magic",
				Description = "Increases magic damage, unlocks new spells, and XP gained for related skills.",
			}),

			Mana = level:NewBase({
				Name = "Mana",
				Description = "Increases mana capacity, casting speed, and XP gained for related skills.",
			}),

			Charisma = level:NewBase({
				Name = "Charisma",
				Description = "Increases discounts, relationship points gained, and XP gained for related skills.",
			}),
		},

		Skill = {
			Mining = level:New({
				Name = "Mining",
				Description = "Increases mining damage and speed.",

				Associations = {
					Strength = 1,
					Stamina = 0.7,
					Constitution = 0.5,

					Dexterity = -0.3,
				},
			}),

			Excavation = level:New({
				Name = "Excavation",
				Description = "Increases digging damage and speed.",

				Associations = {
					Strength = 0.6,
					Constitution = 0.5,
					Stamina = 0.4,

					Dexterity = -0.1,
				},
			}),

			Farming = level:New({
				Name = "Farming",
				Description = "Decreases plant wither rate, increases growth speed, and increases harvest amount.",

				Associations = {
					Constitution = 1,
					Strength = 0.7,
					Stamina = 0.5,
					Dexterity = 0.2,
				},
			}),

			Woodcutting = level:New({
				Name = "Woodcutting",
				Description = "Increases damage against trees and log harvest amount.",

				Associations = {
					Strength = 1,
					Constitution = 0.8,
					Stamina = 0.6,

					Dexterity = -0.4,
				},
			}),

			Carpentry = level:New({

				Name = "Carpentry",
				Description = "",

				Associations = {

					Dexterity = 0.8,
					Constitution = 0.6,
					Stamina = 0.4,
					Strength = 0.3,

					Magic = -0.2,
					Mana = -0.1,
				},
			}),

			Smithing = level:New({

				Name = "Smithing",
				Description = "",

				Associations = {

					Constitution = 0.6,
					Strength = 0.6,
					Dexterity = 0.4,
					Stamina = 0.3,

					Magic = -0.4,
					Mana = -0.3,
				},
			}),

			Papercraft = level:New({

				Name = "Papercraft",
				Description = "",

				Associations = {

					Dexterity = 1,
					Magic = 0.2,
					Mana = 0.1,

					Strength = -0.2,
					Constitution = -0.1,
					Stamina = -0.1,
				},
			}),

			Textilecraft = level:New({

				Name = "Textilecraft",
				Description = "",

				Associations = {

					Dexterity = 1,
					Magic = 0.2,
					Mana = 0.1,

					Strength = -0.2,
					Constitution = -0.1,
					Stamina = -0.1,
				},
			}),

			Leatherwork = level:New({

				Name = "Leatherwork",
				Description = "",

				Associations = {

					Dexterity = 0.8,
					Stamina = 0.3,
					Strength = 0.2,
					Constitution = 0.1,
				},
			}),
		},

		Weapon = {
			Dagger = level:New({
				Name = "Dagger",
				Description = "A small but quick weapon that deals low damage but is very fast. Because of its small size, it won't decrease your magic proficiency.",

				Associations = {},
			}),

			Shortsword = level:New({
				Name = "Shortsword",
				Description = "A sh.",

				Associations = {
					Strength = 0.8,
					Dexterity = 0.6,
					Constitution = 0.4,

					Magic = -0.3,
					Mana = -0.2,
				},
			}),

			Rapier = level:New({
				Name = "Rapier",
				Description = "Increases rapier damage and unlocks new moves.",

				Associations = {
					Dexterity = 1,
					Strength = 0.5,
					Constitution = 0.4,
					Charisma = 0.1,

					Magic = -0.2,
					Mana = -0.1,
				},
			}),

			Saber = level:New({
				Name = "Saber",
				Description = "Sabers are .",

				Associations = {
					Strength = 1.5,
					Constitution = 1,

					Magic = -0.5,
					Mana = -0.3,
					Dexterity = -0.2,
				},
			}),

			Shield = level:New({
				Name = "Shield",
				Description = "Shields are good for defending against physical attacks, but sacrifice speed for defense.",

				Associations = {
					Constitution = 1,
					Stamina = 0.8,
					Strength = 0.5,

					Magic = -0.4,
					Mana = -0.3,
				},
			}),

			Fists = level:New({
				Name = "Fists",
				Description = "Fists are the fastest 'weapon' and have a good amount of damage but have the lowest reach. Gauntlets of some sort are highly recommended.",

				Associations = {
					Strength = 0.7,
					Stamina = 0.5,
					Constitution = 0.5,
					Dexterity = 0.2,
				},
			}),

			Longsword = level:New({
				Name = "Longsword",
				Description = "A large but slow two-handed sword, which deals high damage at the cost of speed.",

				Associations = {
					Strength = 1,
					Stamina = 0.8,
					Constitution = 0.6,

					Dexterity = -0.3,
					Magic = -0.3,
					Mana = -0.2,
				},
			}),

			Greatsword = level:New({
				Name = "Greatsword",
				Description = "The largest sword available. It's very slow, but deals incredibly high damage and breaks both shields and armor if you can hit the enemy.",

				Associations = {
					Strength = 1.4,
					Stamina = 1.2,
					Constitution = 1,

					Magic = -0.8,
					Mana = -0.6,
					Dexterity = -0.4,
				},
			}),

			Katana = level:New({
				Name = "Katana",
				Description = "A two-handed sword of medium speed and high damage popular in the Mochizuki Empire because of its magical properties.",

				Associations = {
					Constitution = 0.8,
					Strength = 0.6,
					Stamina = 0.4,
					Magic = 0.2,
					Mana = 0.1,
				},
			}),

			Shortbow = level:New({
				Name = "Shortbow",
				Description = "",

				Associations = {
					Dexterity = 0.6,
					Stamina = 0.4,
				},
			}),

			Longbow = level:New({
				Name = "Longbow",
				Description = "",

				Associations = {
					Dexterity = 0.8,
					Stamina = 0.6,
					Strength = 0.3,

					Constitution = -0.2,
				},
			}),

			Boomerang = level:New({
				Name = "Katana",
				Description = "",

				Associations = {
					Dexterity = 1,
					Stamina = 0.3,

					Constitution = -0.1,
				},
			}),

			Wand = level:New({
				Name = "Wand",
				Description = "",

				Associations = {
					Magic = 0.8,
					Mana = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Staff = level:New({
				Name = "Staff",
				Description = "",

				Associations = {
					Magic = 1,
					Mana = 0.6,

					Strength = -0.4,
					Stamina = -0.3,
					Constitution = -0.3,
				},
			}),

			Gohei = level:New({
				Name = "Gohei",
				Description = "",

				Associations = {
					Magic = 0.8,
					Mana = 0.6,

					Strength = -0.2,
					Stamina = -0.2,
					Constitution = -0.2,
				},
			}),

			Ofuda = level:New({
				Name = "Ofuda",
				Description = "",

				Associations = {
					Magic = 0.5,
					Mana = 0.4,
					Dexterity = 0.2,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),
		},

		Elements = {
			Fire = level:New({
				Name = "Fire",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Water = level:New({

				Name = "Water",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Earth = level:New({

				Name = "Earth",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Nature = level:New({

				Name = "Nature",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Ice = level:New({

				Name = "Ice",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Metal = level:New({

				Name = "Metal",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Light = level:New({

				Name = "Light",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Darkness = level:New({

				Name = "Darkness",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),

			Healing = level:New({

				Name = "Healing",
				Description = "",

				Associations = {

					Mana = 0.6,
					Magic = 0.4,

					Strength = -0.1,
					Stamina = -0.1,
					Constitution = -0.1,
				},
			}),
		},
	})

	for i, levels in pairs(object) do
		if i ~= "Base" and i ~= "Elements" and i ~= "Skill" and i ~= "Weapon" then
			continue
		end

		for _, lv in pairs(levels) do
			lv.Parent = object
			lv.Player = object.Player
		end
	end

	return object
end

function LevelTable:__UpdateRemote()
	local clientTable = {}

	-- If value is a child of the object: always send the ID,
	-- else: If the index is in Class.__Replicated then send it.
	for i, value in pairs(self) do
		if Signal.Is(value) then
			continue
		end

		if type(value) == "table" then
			if value.__ClassName then
				clientTable[i] = value.Id
				continue
			end
		end

		if self.__Replicated[i] then
			clientTable[i] = value
		end
	end

	-- Send client new information.
	self.Remote:Set(clientTable)
end

function LevelTable:Get(name)
	for _, v in pairs(self) do
		if v[name] then
			return v[name]
		end
	end
end

return LevelTable
