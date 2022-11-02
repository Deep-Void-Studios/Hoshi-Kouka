local subject = workspace.Spawn["Easter Eggs"].Redcube.Redcube
local BadgeService = game:GetService("BadgeService")
local badgeId = 2128058344

subject.Touched:Connect(function(hit)
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			if hit:IsDescendantOf(player.Character) then
				BadgeService:AwardBadge(player.UserId, badgeId)
			end
		end
	end
end)
