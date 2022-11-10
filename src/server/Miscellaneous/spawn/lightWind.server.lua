local force = workspace.Spawn.Base.Float.spawnLight.VectorForce
local t = 0

while task.wait(1) do
	local nX = math.noise(t * math.pi, 0, 0)
	local nZ = math.noise(0, 0, t * math.pi)
	t = t + 0.01

	force.Force = Vector3.new(nX * 2000, 0, nZ * 2000)
end
