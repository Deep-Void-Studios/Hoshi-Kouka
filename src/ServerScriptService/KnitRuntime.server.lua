local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Add all services to startup
Knit.AddServices(game:GetService("ServerScriptService").Services)

-- Add all classes to startup
Knit.AddServicesDeep(game:GetService("ServerScriptService").Classes.BaseClass)

-- Start all modules
Knit.Start():catch(warn)

return true
