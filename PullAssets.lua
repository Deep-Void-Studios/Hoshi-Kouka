local disallowedClasses = {
	Folder = true,
	SoundGroup = true,
	Script = true,
	LocalScript = true,
	ModuleScript = true,
}

local folderClasses = {
	Folder = true,
	SoundGroup = true,
}

local function SaveAssetToFilesystem(Asset, Path)
	for _, Instance in pairs(Asset:GetChildren()) do
		local path = Path .. "/" .. Instance.Name
		print(path)
		if not disallowedClasses[Instance.ClassName] then
			remodel.writeModelFile(path .. ".rbxmx", Instance)
		elseif folderClasses[Instance.ClassName] then
			remodel.createDirAll(path)
			SaveAssetToFilesystem(Instance, path)
		else
			print(Instance.Name .. " is a disallowed class.")
		end
	end
end

local Datamodel = remodel.readPlaceFile("place.rbxlx")

local toSave = {
	{ Datamodel.ServerStorage.models, "./assets/models" },
	{ Datamodel.Workspace, "./workspace" },
	{ Datamodel.StarterGui, "./src/gui" },
	{ Datamodel.SoundService, "./audio" },
}

for _, v in pairs(toSave) do
	local model = v[1]
	local path = v[2]

	SaveAssetToFilesystem(model, path)
end
