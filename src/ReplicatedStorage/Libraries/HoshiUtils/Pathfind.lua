local copy = require(script.Parent.DeepCopy)

local function pathfind(tab, path)
	path = copy(path)
	local val = tab[path[1]]

	if #path == 1 then
		return val
	else
		table.remove(path, 1)
		return pathfind(val, path)
	end
end

return pathfind
