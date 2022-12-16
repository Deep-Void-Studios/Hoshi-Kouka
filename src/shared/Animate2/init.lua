local Config = {
	["Debug"] = false, --Print debug messages
	["PlayToolEquippedAnimation"] = true, --Put right hand up if tool is equipped
	["AllowEmotes"] = true, --Whether emotes can be used (e.g. "/e dance")
	["TimeInBetweenIdleAnimationChange"] = 10, --How much time before IdleAnim is changed to IdleAnim2
	["ChattedEvent"] = false, --If false, the module will listen to Player.Chatted for emotes. Otherwise, it will listen to this event.
}

--[[
	Made by a3nim
	Version 1.12

	Modified by Aimi
]]

local doNotReplace = {
	ToolAnimation = true,
	IdleAnimation2 = true,
	SitAnimation = true,
	SwimIdleAnimation = true,
}

return function(Rig, CustomConfig)
	local function Player()
		return game:GetService("Players").LocalPlayer
	end
	local function Humanoid()
		return Rig:WaitForChild("Humanoid")
	end

	if CustomConfig then
		for i, v in pairs(CustomConfig) do
			if Config[i] ~= nil then
				Config[i] = v
			end
		end
	end

	local Animations = {}
	local PreloadAnimation = require(script:WaitForChild("PreloadAnimation"))
	local AnimationsConfigFolder
	if Humanoid().RigType == Enum.HumanoidRigType.R15 then
		AnimationsConfigFolder = script:WaitForChild("Animations")
	else
		AnimationsConfigFolder = script:WaitForChild("Animations R6")
	end

	if Player() and Humanoid().RigType == Enum.HumanoidRigType.R15 then
		local player = Player()

		local description = game:GetService("Players"):GetHumanoidDescriptionFromUserId(player.UserId)

		for _, v in pairs(AnimationsConfigFolder:GetChildren()) do
			if doNotReplace[v.Name] then
				continue
			end

			print(v.Value, description[v.Name])

			v.Value = description[v.Name]
		end
	end

	local function NewAnimation(Name, ID, Priority, IsEmote, Looped)
		Animations[Name] = { ID, nil, Priority, IsEmote, Looped }
		PreloadAnimation(ID)
	end

	local function GetAnimationId(AnimationName)
		return AnimationsConfigFolder:WaitForChild(AnimationName).Value
	end
	local function GetAnimationSpeed(AnimationName)
		--Some animations don't have their own config value like tool equip and emotes, return 1 for these
		if AnimationsConfigFolder:FindFirstChild(AnimationName) then
			return AnimationsConfigFolder:WaitForChild(AnimationName):GetAttribute("Speed")
		end
		return 1
	end

	local function PlayAnim(ID, Looped)
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(ID)
		local anim_track = Humanoid():LoadAnimation(anim)
		anim_track.Name = "LocalAnimation" --So you can differentiate local animations and animations which have been replicated.
		if Looped ~= nil then
			anim_track.Looped = Looped
		end
		anim_track:Play()

		return anim_track
	end

	local function RunAnimation(active, Anim)
		--[[
			[1] = ID,
			[2] = Track,
			[3] = Priority,
			[4] = Is Emote,
			[5] = Is Looped
		]]
		if active then
			if not Animations[Anim][2] then
				print("running", Animations[Anim])
				Animations[Anim][2] = PlayAnim(Animations[Anim][1], Animations[Anim][5])
				Animations[Anim][2].Priority = Animations[Anim][3]
				--print("Play:", Anim)
			end
		else
			if Animations[Anim][2] then
				--print("Stop:", Anim)
				Animations[Anim][2]:Stop(0.2)
				Animations[Anim][2] = nil
			end
		end

		if Animations[Anim][2] then
			Animations[Anim][2]:AdjustSpeed(GetAnimationSpeed(Anim))
		end
	end

	NewAnimation("IdleAnimation", GetAnimationId("IdleAnimation"), Enum.AnimationPriority.Core, false, true)
	NewAnimation("IdleAnimation2", GetAnimationId("IdleAnimation2"), Enum.AnimationPriority.Core, false, true)
	NewAnimation("RunAnimation", GetAnimationId("RunAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("WalkAnimation", GetAnimationId("WalkAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("JumpAnimation", GetAnimationId("JumpAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("FallAnimation", GetAnimationId("FallAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("ClimbAnimation", GetAnimationId("ClimbAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("SwimAnimation", GetAnimationId("SwimAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("SwimIdleAnimation", GetAnimationId("SwimIdleAnimation"), Enum.AnimationPriority.Idle, false)
	NewAnimation("ToolAnimation", GetAnimationId("ToolAnimation"), Enum.AnimationPriority.Movement, false)
	NewAnimation("SitAnimation", GetAnimationId("SitAnimation"), Enum.AnimationPriority.Movement, false)

	--Update the animations if they are changed
	for _, v in ipairs(AnimationsConfigFolder:GetChildren()) do
		v:GetPropertyChangedSignal("Value"):Connect(function()
			Animations[v.Name][1] = v.Value
			if Animations[v.Name][2] then
				RunAnimation(false, v.Name)
				RunAnimation(true, v.Name)
			end
		end)
		v:GetAttributeChangedSignal("Speed"):Connect(function()
			if Animations[v.Name][2] then
				Animations[v.Name][2]:AdjustSpeed(GetAnimationSpeed(v.Name))
			end
		end)
	end

	local function StopAllEmotes()
		for _, anim in pairs(Animations) do
			if anim[4] == true then --if is emote
				if anim[2] then --if track is playing
					anim[2]:Stop()
					anim[2] = nil
				end
			end
		end
	end

	RunAnimation(true, "IdleAnimation")
	local LastChangedIdleAnim, CurrentIdleAnim = os.clock(), 1

	if game:GetService("RunService"):IsClient() then
		--For some reason, the idle animation 2 is broken on NPC's, so we'll only enable on client

		game:GetService("RunService").Heartbeat:Connect(function()
			if CurrentIdleAnim == 1 then
				if os.clock() - Config.TimeInBetweenIdleAnimationChange > LastChangedIdleAnim then
					CurrentIdleAnim = 2
					LastChangedIdleAnim = os.clock()
					RunAnimation(false, "IdleAnimation")
					RunAnimation(true, "IdleAnimation2")
				end
			else
				local IdleAnim2Length = Animations["IdleAnimation2"][2] and Animations["IdleAnimation2"][2].Length or 0
				if os.clock() - IdleAnim2Length > LastChangedIdleAnim then
					CurrentIdleAnim = 1
					LastChangedIdleAnim = os.clock()
					RunAnimation(false, "IdleAnimation2")
					RunAnimation(true, "IdleAnimation")
				end
			end
		end)
	end

	Humanoid().Running:Connect(function(speed)
		--Stops/starts the running animation if they stop/start moving, as there is no "idle" state
		StopAllEmotes()
		if speed < 1 then
			RunAnimation(false, "RunAnimation")
			RunAnimation(false, "WalkAnimation")
		elseif Humanoid():FindFirstChild("HumanoidDescription") then
			local height = Humanoid().HumanoidDescription.HeightScale

			if speed < 16 * height then
				print("walk")
				RunAnimation(true, "WalkAnimation")
				RunAnimation(false, "RunAnimation")
				Animations["WalkAnimation"][2]:AdjustSpeed(GetAnimationSpeed("WalkAnimation") * speed / 16)
			else
				print("run")
				RunAnimation(true, "RunAnimation")
				RunAnimation(false, "WalkAnimation")
				Animations["RunAnimation"][2]:AdjustSpeed(GetAnimationSpeed("RunAnimation") * speed / 16)
			end
		else
			RunAnimation(true, "RunAnimation")
			Animations["RunAnimation"][2]:AdjustSpeed(GetAnimationSpeed("RunAnimation") * speed / 16)
		end
	end)
	Humanoid().Swimming:Connect(function(speed)
		StopAllEmotes()
		if speed < 1 then
			RunAnimation(false, "SwimAnimation")
			RunAnimation(true, "SwimIdleAnimation")
		else
			RunAnimation(true, "SwimAnimation")
			RunAnimation(false, "SwimIdleAnimation")
		end
	end)

	Humanoid().Climbing:Connect(function(speed)
		--Pauses the climbing animation if they stop moving while climbing
		StopAllEmotes()
		if Animations["ClimbAnimation"][2] then
			if speed == 0 then
				Animations["ClimbAnimation"][2]:AdjustSpeed(0)
			else
				Animations["ClimbAnimation"][2]:AdjustSpeed(GetAnimationSpeed("ClimbAnimation") * speed / 5)
			end
		end
	end)

	local function ToolIsEquipped()
		--Play tool equipped animation if tool is equipped
		if Config.PlayToolEquippedAnimation == true then
			local IsEquipped = false
			for _, v in ipairs(Humanoid().Parent:GetChildren()) do
				if v:IsA("Tool") then
					IsEquipped = true
					break
				end
			end
			RunAnimation(IsEquipped, "ToolAnimation")
		end
	end
	Humanoid().Parent.ChildAdded:Connect(ToolIsEquipped)
	Humanoid().Parent.ChildRemoved:Connect(ToolIsEquipped)
	ToolIsEquipped()

	Humanoid():SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	Humanoid().StateChanged:Connect(function(OldState, NewState)
		if Config.Debug == true then
			print(OldState.Name .. " --> " .. NewState.Name)
		end

		StopAllEmotes()

		RunAnimation(false, "RunAnimation")
		RunAnimation(false, "ClimbAnimation")
		RunAnimation(false, "JumpAnimation")
		RunAnimation(false, "FallAnimation")
		RunAnimation(false, "SwimAnimation")
		RunAnimation(false, "SwimIdleAnimation")
		RunAnimation(false, "SitAnimation")

		if NewState == Enum.HumanoidStateType.Climbing then
			RunAnimation(true, "ClimbAnimation")
		elseif NewState == Enum.HumanoidStateType.Running then
			if Humanoid().MoveDirection ~= Vector3.new() then
				RunAnimation(true, "RunAnimation")
			end
		elseif NewState == Enum.HumanoidStateType.Freefall then
			RunAnimation(true, "JumpAnimation")
		elseif NewState == Enum.HumanoidStateType.Swimming then
			if Humanoid().MoveDirection ~= Vector3.new() then
				RunAnimation(true, "SwimAnimation")
			end
		elseif NewState == Enum.HumanoidStateType.Seated then
			RunAnimation(true, "SitAnimation")
		end
	end)

	--EMOTES

	NewAnimation("DanceAnim", 507771019, Enum.AnimationPriority.Action, true)
	NewAnimation("Dance2Anim", 507776043, Enum.AnimationPriority.Action, true)
	NewAnimation("Dance3Anim", 507777268, Enum.AnimationPriority.Action, true)
	NewAnimation("LaughAnim", 507770818, Enum.AnimationPriority.Action, true, false)
	NewAnimation("PointAnim", 507770453, Enum.AnimationPriority.Action, true, false)
	NewAnimation("WaveAnim", 507770239, Enum.AnimationPriority.Action, true, false)
	NewAnimation("CheerAnim", 507770677, Enum.AnimationPriority.Action, true, false)
	NewAnimation("PoseAnim", 5392107832, Enum.AnimationPriority.Action, true)

	local ChattedEvent = Config.ChattedEvent
	if not ChattedEvent and Player() then
		ChattedEvent = Player().Chatted
	end
	if ChattedEvent then
		ChattedEvent:Connect(function(message)
			if Config.AllowEmotes == true then
				if message:lower() == "/e dance" then
					RunAnimation(true, "DanceAnim")
				elseif message:lower() == "/e dance2" then
					RunAnimation(true, "Dance2Anim")
				elseif message:lower() == "/e dance3" then
					RunAnimation(true, "Dance3Anim")
				elseif message:lower() == "/e laugh" then
					RunAnimation(true, "LaughAnim")
				elseif message:lower() == "/e point" then
					RunAnimation(true, "PointAnim")
				elseif message:lower() == "/e pose" then
					RunAnimation(true, "PoseAnim")
				elseif message:lower() == "/e wave" then
					RunAnimation(true, "WaveAnim")
				elseif message:lower() == "/e cheer" then
					RunAnimation(true, "CheerAnim")
				end
			end
		end)
	end
end
