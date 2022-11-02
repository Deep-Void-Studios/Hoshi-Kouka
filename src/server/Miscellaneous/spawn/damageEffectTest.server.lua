local highlight = workspace.Spawn.Props.DamageEffectTest.Highlight

local function flash()
	highlight.Enabled = true
	task.wait(0.15)
	highlight.Enabled = false
end

while task.wait(1) do
	flash()
end
