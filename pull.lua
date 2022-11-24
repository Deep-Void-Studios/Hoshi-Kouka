local disallowedClasses = {
	Folder = true,
	SoundGroup = true,
	Script = true,
	LocalScript = true,
	ModuleScript = true,
	Camera = true,
}

local folderClasses = {
	Folder = true,
	SoundGroup = true,
}

local function SaveAssetToFilesystem(Asset, Path)
	for _, Instance in pairs(Asset:GetChildren()) do
		local path = Path .. "/" .. Instance.Name
		if not disallowedClasses[Instance.ClassName] then
			remodel.writeModelFile(path .. ".rbxmx", Instance)
		elseif folderClasses[Instance.ClassName] then
			remodel.createDirAll(path)
			SaveAssetToFilesystem(Instance, path)
			--else
			--print(Instance.Name .. " is a disallowed class.")
		end
	end
end

local Datamodel = remodel.readPlaceFile("place.rbxlx")

local toSave = {
	-- { Datamodel.ServerStorage.Models, "./assets/models" },
	-- { Datamodel.Workspace, "./workspace" },
	{ Datamodel.StarterGui, "./src/gui" },
	-- { Datamodel.SoundService, "./audio" },
	-- { Datamodel.Chat, "./src/chat" },
	-- { Datamodel.ReplicatedStorage, "./src/shared" },
}

-- local fullService = {
-- { Datamodel.Lighting, "./src/lighting.rbxmx" },
-- { Datamodel.MaterialService, "./src/materials.rbxmx" },
-- }

for _, v in pairs(toSave) do
	local model = v[1]
	local path = v[2]

	SaveAssetToFilesystem(model, path)
end

-- for _, v in pairs(fullService) do
-- 	local service = v[1]
-- 	local path = v[2]

-- 	remodel.writeModelFile(path, service)
-- end
