-- Get BaseClass
local BaseClass = require(script.Parent)

-- Make class
local Folder = BaseClass:__MakeClass("Folder")

-- Accept children
function Folder:ChildAdded(object, index)
	index = index or #self + 1

	table.insert(self, index, object)

	object.Index = index
end

return Folder
