local function SaveAssetToFilesystem(Asset, Path)
	for _, Instance in pairs(Asset:GetChildren()) do
		local path = Path .. "/" .. Instance.Name
		if Instance.ClassName ~= "Folder" and Instance.ClassName ~= "SoundGroup" then
			remodel.writeModelFile(path .. ".rbxmx", Instance)
		else
			remodel.createDirAll(path)
			SaveAssetToFilesystem(path, Instance)
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
