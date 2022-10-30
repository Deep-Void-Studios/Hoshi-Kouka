local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local MongoStore = require(script.MongoStore)
MongoStore:Authorize("data-tllho", "Q85QAUOuPbFoPUy108v3Xc01UX5mErZtl6G4N5YnFXlyMXoXJfoRbsbq603jxGy5")
local datastore = MongoStore:GetDataStore("Datastore", "TerrainData")

-- Create service
local DatabaseService = Knit.CreateService {
	-- Set name
	Name = "DatabaseService",
	
	-- Make client table
	Client = {}
}

function DatabaseService:Get(key)
	local data
	
	for attempts = 1, 5 do
		local success, err = pcall(function()
			data = datastore:GetAsync(key)
		end)
		
		if success then
			break
		elseif attempts < 5 then
			warn(err)
		else
			error(err)
		end
	end
	
	return data
end

function DatabaseService:Set(key, value)
	for attempts = 1, 5 do
		local success, err = pcall(function()
			datastore:SetAsync(key, value)
		end)

		if success then
			break
		elseif attempts < 5 then
			warn(err)
		else
			error(err)
		end
	end
end

return DatabaseService
