function splitstring(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

local function GetInstanceFromDatamodel(Datamodel,StringPath)
	local CurrentObjectReference = Datamodel

	for _, ObjectName in pairs(splitstring(StringPath,".")) do
		if CurrentObjectReference:FindFirstChild(ObjectName) ~= nil then
			CurrentObjectReference = CurrentObjectReference[ObjectName]
		else
			error(ObjectName.." was not found.")
			return nil
		end
	end

	return CurrentObjectReference
