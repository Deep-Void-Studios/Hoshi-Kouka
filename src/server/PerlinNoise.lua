local PerlinNoiseAPI = {}

function PerlinNoiseAPI.new(coords,amplitude,octaves,persistence)
	coords = coords or {}
	octaves = octaves or 1
	persistence = persistence or 0.5
	if #coords > 4 then
		error("The Perlin Noise API doesn't support more than 4 dimensions!")
	else
		if octaves < 1 then
			error("Octaves have to be 1 or higher!")
		else
			local X = coords[1] or 0
			local Y = coords[2] or 0
			local Z = coords[3] or 0
			local W = coords[4] or 0
			
			amplitude = amplitude or 10
			octaves = octaves-1
			if W == 0 then
				local perlinvalue = (math.noise(X/amplitude,Y/amplitude,Z/amplitude))
				if octaves ~= 0 then
					for i = 1,octaves do
						perlinvalue = perlinvalue+(math.noise(X/(amplitude*(persistence^i)),Y/(amplitude*(persistence^i)),Z/(amplitude*(persistence^i)))/(2^i))
					end
				end
				return perlinvalue
			else
				local AB = math.noise(X/amplitude,Y/amplitude)
				local AC = math.noise(X/amplitude,Z/amplitude)
				local AD = math.noise(X/amplitude,W/amplitude)
				local BC = math.noise(Y/amplitude,Z/amplitude)
				local BD = math.noise(Y/amplitude,W/amplitude)
				local CD = math.noise(Z/amplitude,W/amplitude)
					
				local BA = math.noise(Y/amplitude,X/amplitude)
				local CA = math.noise(Z/amplitude,X/amplitude)
				local DA = math.noise(W/amplitude,X/amplitude)
				local CB = math.noise(Z/amplitude,Y/amplitude)
				local DB = math.noise(W/amplitude,Y/amplitude)
				local DC = math.noise(W/amplitude,Z/amplitude)
				
				local ABCD = AB+AC+AD+BC+BD+CD+BA+CA+DA+CB+DB+DC
				
				local perlinvalue = ABCD/12
				
				if octaves ~= 0 then
					for i = 1,octaves do
						local AB = math.noise(X/(amplitude*(persistence^i)),Y/(amplitude*(persistence^i)))
						local AC = math.noise(X/(amplitude*(persistence^i)),Z/(amplitude*(persistence^i)))
						local AD = math.noise(X/(amplitude*(persistence^i)),W/(amplitude*(persistence^i)))
						local BC = math.noise(Y/(amplitude*(persistence^i)),Z/(amplitude*(persistence^i)))
						local BD = math.noise(Y/(amplitude*(persistence^i)),W/(amplitude*(persistence^i)))
						local CD = math.noise(Z/(amplitude*(persistence^i)),W/(amplitude*(persistence^i)))
						
						local BA = math.noise(Y/(amplitude*(persistence^i)),X/(amplitude*(persistence^i)))
						local CA = math.noise(Z/(amplitude*(persistence^i)),X/(amplitude*(persistence^i)))
						local DA = math.noise(W/(amplitude*(persistence^i)),X/(amplitude*(persistence^i)))
						local CB = math.noise(Z/(amplitude*(persistence^i)),Y/(amplitude*(persistence^i)))
						local DB = math.noise(W/(amplitude*(persistence^i)),Y/(amplitude*(persistence^i)))
						local DC = math.noise(W/(amplitude*(persistence^i)),Z/(amplitude*(persistence^i)))
						
						local ABCD = AB+AC+AD+BC+BD+CD+BA+CA+DA+CB+DB+DC
						
						perlinvalue = perlinvalue+((ABCD/12)/(2^i))
					end
				end
				return perlinvalue
			end
		end
	end
end

return PerlinNoiseAPI
