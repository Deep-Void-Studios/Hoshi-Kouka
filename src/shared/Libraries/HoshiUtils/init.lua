local module = {}

for i, v in pairs(script:GetDescendants()) do
	module[v.Name] = require(v)
end

return module
