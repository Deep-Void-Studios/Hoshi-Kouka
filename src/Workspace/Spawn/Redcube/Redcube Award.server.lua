local subject = script.Parent
local BadgeService = game:GetService("BadgeService")
local badgeId = 2128058344

subject.Touched:Connect(function(hit)
	for i, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			if hit:IsDescendantOf(player.Character) then
				BadgeService:AwardBadge(player.UserId, badgeId)
			end
		end
	end
end)
