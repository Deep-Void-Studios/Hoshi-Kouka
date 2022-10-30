local module = {}

type material = {
	Name : string,
	Material : Enum.Material,
	Hardness : number,
	Tier : number,
	Tool : any
}

function module:GetMaterial(material : Enum.Material) : material
	return require(script:WaitForChild(material.Name))
end

return module
