local Base = {}
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)
local CommService = require(game:GetService("ServerScriptService").Services.CommService)
local ClassComm = CommService:Get("ClassComm")

Base.__Class = Base
Base.__ClassName = "BaseClass"
Base.__Count = 0
Base.__Defaults = {}
Base.__Replicated = {}
Base.__DoNotCopy = {
	Remote = true,
	Updated = true,
	Removing = true,
	Comm = true,
	Id = true,
	AuthorizedUsers = true,
	__Serial = true
}

local function deepCopy(t)
	local new = {}
	
	for i, v in pairs(t) do
		if type(v) == "table" then
			new[i] = deepCopy(v)
		else
			new[i] = v
		end
	end
	
	return new
end

function Base:New(data)
	data = data or {}
	self.__Count += 1
	
	local object = setmetatable({
		table.unpack(deepCopy(self.__Defaults)),
		
		Id = self.__ClassName..self.__Count,
		AuthorizedUsers = {},
		Updated = Signal.new(),
		Removing = Signal.new(),
		Comm = ClassComm:CreateSignal(self.__ClassName..self.__Count)
	}, self)
	
	self.__index = self
	
	for i, v in pairs(data) do
		if i == "Id" or i == "AuthorizedUsers" or i == "Updated" or i == "Removing" or i == "Comm" then continue end
		
		object[i] = v
	end
	
	object.Remote = ClassComm:CreateProperty(self.__ClassName..self.__Count, false)

	object.Updated:Connect(function()
		object:__SetRemote()
		object:__UpdateSerial()
	end)

	object.Comm:Connect(function(player, action, ...)
		if not object.AuthorizedUsers[player.UserId] then
			warn("Unauthorized player "..player.Name.." attempted to access object "..object.Id..".")
			return
		end

		local func = object["__Client"..action]

		if func then
			func(object, ...)
		else
			warn("Received invalid request: "..action.." from user, "..player.Name..".")
		end
	end)
	
	object.Updated:Fire()
	
	return object
end

function Base:__SetRemote()
	local clientTable = {}

	-- If value is a child of the object: always send the ID,
	-- else: If the index is in Class.__Replicated then send it.
	for i, value in pairs(self) do
		if Signal.Is(value) then continue end
		
		if type(value) == "table" then
			if value.__ClassName then
				clientTable[i] = value.Id
				continue
			end
		end

		if self.__Replicated[i] then
			clientTable[i] = value
		end
	end

	-- Send client new information.
	self.Remote:Set(clientTable)
end

function Base:__UpdateSerial()
	local serial = {}
	self.__Serial = serial
	
	serial.__ClassName = self.__ClassName
	
	for i, v in pairs(self) do
		if self.__DoNotCopy[i] then continue end
		
		if type(v) == "table" then
			if Signal.Is(v) then continue end
			
			if v.__ClassName then
				serial[i] = v.__Serial
			else
				serial[i] = v
			end
		else
			serial[i] = v
		end
	end
end

function Base:AllowUser(player)
	self.AuthorizedUsers[player.UserId] = true
	self.Updated:Fire()
end

function Base:DisallowUser(player)
	self.AuthorizedUsers[player.UserId] = nil
	self.Updated:Fire()
end

function Base:Clone()
	local new = self.__Class:New()

	self.__Count += 1

	for i, v in pairs(self) do
		if i == "Id" then
			new[i] = self.__Count
		elseif self.__DoNotCopy[i] then
			continue
		elseif type(v) == "table" then
			if Signal.Is(v) then continue end
			if v.__ClassName then continue end
			
			new[i] = deepCopy(v)
		else
			new[i] = v
		end
	end
	
	new.Updated:Fire()
	
	return new
end

-- Destroy an object and trigger relevant functions.
function Base:Destroy()
	self.Removing:Fire()
	
	self.Updated:Destroy()
	self.Removing:Destroy()
	self.Comm:Destroy()
	self.Remote:Destroy()

	if self.Parent then
		self.Parent:ChildRemoved(self.Index)
	end

	setmetatable(self, nil)
	table.clear(self)
end

function Base:SetParent(parent)
	local oldParent = self.Parent

	if oldParent then
		oldParent:ChildRemoved(self.Index)
	end

	if parent then
		parent:ChildAdded(self)
		self.Parent = parent
		self:SetPlayer(parent.Player)
	else
		self.Parent = nil
		self:SetPlayer()
	end

	self.Updated:Fire()
end

function Base:SetPlayer(player)
	self.Player = player

	for i, obj in pairs(self) do
		if i == "Parent" then continue end
		if type(obj) ~= "table" then continue end
		if obj.Is then continue end
		if not obj.__ClassName then continue end

		obj:SetPlayer(player)
	end
end

function Base:ChildAdded()
	error(self.ClassName.."cannot accept children.")
end

function Base:ChildRemoved()
	error(self.ClassName.."cannot remove children.")
end

function Base:__MakeClass(name)
	local class = Knit.CreateService {Name = name}

	class.__Class = class
	class.__ClassName = name
	class.__Count = 0
	class.__Defaults = {}
	class.__Replicated = {}
	
	setmetatable(class, self)
	
	self.__index = self
	
	return class
end

return Base
