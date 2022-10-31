while wait() do
	local success, err = pcall(function()
		local starterGui = game:GetService('StarterGui')
		
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	end)
	
	if success then
		break
	else
		warn(err)
	end
end
