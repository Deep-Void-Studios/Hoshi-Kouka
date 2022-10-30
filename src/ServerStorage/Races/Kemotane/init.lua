local race = {
	Name = "Kemotane",

	Description = 
		"A race very similar in appearance to humans. It is believed that they both stem from the same race but it is unknown which came first. They are very",

	StatBonuses = {
		Constitution = 3,
		Strength = 2,
		Stamina = 5,
		Dexterity = 1,
		Intelligence = 2,
		ManaCapacity = 4,
		Charisma = 4
	},
	
	Subtypes = {
		KemotaneType = {
			Secret = false,
			-- TODO ADD MORE TODO
			require(script.Neko)
		},
		IsYukimura = {
			Secret = true,
			require(script.Yukimura)
		}
	},

	Traits = {
		{
			-- TODO UNFINISHED TODO
			Name = "Kemotane Nature",
			Description = "Lower Self Control",
			Type = "Race",
			Cost = 0,
		}
	}
	
	-- Note: One of the easier races. Recommended for new players,
	-- as they have no major disadvantages and have a very high level of
	-- stamina (which is good for running from fights).
}

return race
