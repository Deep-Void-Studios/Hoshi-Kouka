local subject = workspace.Spawn["Easter Eggs"].Orb.CreationOrb
local BadgeService = game:GetService("BadgeService")
local badgeId = 2128058548

subject.Touched:Connect(function(hit)
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			if hit:IsDescendantOf(player.Character) then
				BadgeService:AwardBadge(player.UserId, badgeId)
			end
		end
	end
end)
