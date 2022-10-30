local function copy(table)
	local new = {}
	
	for i, v in pairs(table) do
		if i == "Parent" or i == "Remote" then continue end
		
		if type(v) == "table" then
			new[i] = copy(v)
		else
			new[i] = v
		end
	end
	
	setmetatable(new, getmetatable(table))
	
	return new
end

return copy