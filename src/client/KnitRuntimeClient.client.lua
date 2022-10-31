local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Add all services to startup
Knit.AddControllers(game:GetService("ReplicatedStorage").Controllers)

-- Start all modules
Knit.Start():catch(warn)
