local highlight = script.Parent.Highlight

local function flash()
	highlight.Enabled = true
	wait(0.15)
	highlight.Enabled = false
end

while wait(1) do
	flash()
end
