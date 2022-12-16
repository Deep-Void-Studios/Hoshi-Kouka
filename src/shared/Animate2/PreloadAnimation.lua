local ContentProvider = game:GetService("ContentProvider")

function PreloadAnimation(ID)
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. tostring(ID)
	task.defer(function()
		ContentProvider:PreloadAsync({ anim })
	end)
end

return PreloadAnimation
