local race = {
	Name = "Human",
	
	Description = 
	"One of the least remarkable races. They are fairly below average in most ways, but are surprisingly adaptable. Despite having no specialty, they can learn to do almost anything other races can do with time. They are also much more common even though they are weak, as they tend to live shorter lives but do a lot in the time that they have, and tend to have more children than other races.",
	
	StatBonuses = {
		Constitution = 2,
		Strength = 2,
		Stamina = 2,
		Dexterity = 2,
		Intelligence = 2,
		ManaCapacity = 2,
		Charisma = 2
	},
	
	Subtypes = {}, -- There are no human subtypes planned, yet.
	
	Traits = {}
	-- Does not support custom conditions yet (only static stat bonuses).
	-- Planned: Strength In Numbers - Stat bonus around other humans up to 10.
	
	-- Note: While it will probably be fairly common for players
	-- to choose human as their race, it is considered a difficult
	-- race, so kemotane is more recommended for players who are
	-- either new or want to be more human with less challenge.
}

return race
