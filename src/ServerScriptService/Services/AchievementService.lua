local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)

local BadgeService = game:GetService("BadgeService")

-- Create service
local AchievementService = Knit.CreateService {
	-- Set name
	Name = "AchievementService",
	
	-- Client table
	Client = {
		AchievementGet = Knit.CreateSignal()
	}
}

function AchievementService:Award(player : Player, badgeId)
	-- Return if user already has badge
	if BadgeService:UserHasBadgeAsync(player.UserId, badgeId) then return end
	
	-- Award badge
	BadgeService:AwardBadge(player.UserId, badgeId)
	
	-- Fire achievement get signal for client
	AchievementService.Client.AchievementGet:Fire(player, badgeId)
	
	-- Get MessageService and badge information
	local MessageService = Knit.GetService("MessageService")
	local badgeInfo = BadgeService:GetBadgeInfoAsync(badgeId)
	
	-- Announce achievement
	MessageService:SystemMessage(player.DisplayName.." has gotten the achievement ["..badgeInfo.Name.."]!")
end

return AchievementService

