local contentProvider = game:GetService("ContentProvider")

local toLoad = {
	"rbxassetid://6228337171"
}

contentProvider:PreloadAsync(toLoad)
