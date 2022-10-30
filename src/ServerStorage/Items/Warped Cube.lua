local process = require(script.Parent.__DataProcessor).Process

local data = {
	Name = "Warped Cube",
	Description = "",
	Type = "Material",
	Amount = 1,
	
	Properties = {
		Volume = 8,
		Weight = 20
	},
	
	Actions = {
		Drop = true,
		DropAll = true
	},
	
	Model = "Warped Cube",
	
	Image = "rbxassetid://8479237906"
}

return process(data)
