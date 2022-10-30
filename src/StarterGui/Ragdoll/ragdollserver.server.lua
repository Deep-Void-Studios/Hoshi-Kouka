--[[INFORMATION------------------------------------------------[[
	ARTFVL's Ragdoll Script (Ragdoll Testing v0.2)
	Updated: August 18th 2020
	
	PLACE THE FOLDER INSIDE GAME.STARTERGUI
	
	Credits:
		ARTFVL - programming
		EchoReaper - ragdoll script it's based on
--]]-----------------------------------------------------------]]

repeat wait() until script.Parent.Parent.Parent:IsA("Player")
repeat wait() until script.Parent.Parent.Parent.Character:FindFirstChild("Humanoid")

--[[SETTINGS---------------------------------------------------]]
	local flag_clonecharacter = false
		local flag_autocleanup = true
			local flag_cleanuptime = 60*1
			
	local BreakJointsOnDeath = true
--[[-----------------------------------------------------------]]

local player = script.Parent.Parent.Parent
local character = player.Character
local humanoid = character.Humanoid--character:WaitForChild("Humanoid")
humanoid.BreakJointsOnDeath = BreakJointsOnDeath

local variables = script.Parent.variables--script.Parent:WaitForChild("variables")
local variables_ragdoll = variables.ragdoll--variables:WaitForChild("ragdoll")

local events = script.Parent.events--script.Parent:WaitForChild("events")
local events_variableserver = events.variableserver--events:WaitForChild("variableserver")

local functions = script.Parent.functions--script.Parent:WaitForChild("functions")
local functions_remoteragdoll = functions.remoteragdoll--functions:WaitForChild("remoteragdoll")
local functions_remoteragdollvelocity = functions.remoteragdollvelocity--functions:WaitForChild("remoteragdollvelocity")
local functions_ragdoll = functions.ragdoll--functions:WaitForChild("ragdoll")

local PhysicsService = game:GetService("PhysicsService")
local Debris = game:GetService("Debris")

local constraintfolder = character:FindFirstChild("RagdollConstraints")
if not constraintfolder then constraintfolder = Instance.new("Folder",character); constraintfolder.Name = "RagdollConstraints" end
local collisionfolder = character:FindFirstChild("CollisionConstraints")
if not collisionfolder then collisionfolder = Instance.new("Folder",character); collisionfolder.Name = "CollisionConstraints" end

local noclipgrouptest = pcall(function() PhysicsService:GetCollisionGroupId("noclip") end)
if not noclipgrouptest then
	PhysicsService:CreateCollisionGroup("noclip")
	PhysicsService:CollisionGroupSetCollidable("Default","noclip",false)
end

local bodyparts = {
	HumanoidRootPart = character:WaitForChild("HumanoidRootPart");
	
	LowerTorso = character:WaitForChild("LowerTorso");
	
	LeftUpperLeg = character:WaitForChild("LeftUpperLeg");
	LeftLowerLeg = character:WaitForChild("LeftLowerLeg");
	LeftFoot = character:WaitForChild("LeftFoot");
	
	RightUpperLeg = character:WaitForChild("RightUpperLeg");
	RightLowerLeg = character:WaitForChild("RightLowerLeg");
	RightFoot = character:WaitForChild("RightFoot");
	
	UpperTorso = character:WaitForChild("UpperTorso");
	
	LeftUpperArm = character:WaitForChild("LeftUpperArm");
	LeftLowerArm = character:WaitForChild("LeftLowerArm");
	LeftHand = character:WaitForChild("LeftHand");
	
	RightUpperArm = character:WaitForChild("RightUpperArm");
	RightLowerArm = character:WaitForChild("RightLowerArm");
	RightHand = character:WaitForChild("RightHand");
	
	Head = character:WaitForChild("Head");
}

local motors = {
	Root = bodyparts.LowerTorso:WaitForChild("Root");
	
	LeftHip = bodyparts.LeftUpperLeg:WaitForChild("LeftHip");
	LeftKnee = bodyparts.LeftLowerLeg:WaitForChild("LeftKnee");
	LeftAnkle = bodyparts.LeftFoot:WaitForChild("LeftAnkle");
	
	RightHip = bodyparts.RightUpperLeg:WaitForChild("RightHip");
	RightKnee = bodyparts.RightLowerLeg:WaitForChild("RightKnee");
	RightAnkle = bodyparts.RightFoot:WaitForChild("RightAnkle");
	
	Waist = bodyparts.UpperTorso:WaitForChild("Waist");
	
	LeftShoulder = bodyparts.LeftUpperArm:WaitForChild("LeftShoulder");
	LeftElbow = bodyparts.LeftLowerArm:WaitForChild("LeftElbow");
	LeftWrist = bodyparts.LeftHand:WaitForChild("LeftWrist");
	
	RightShoulder = bodyparts.RightUpperArm:WaitForChild("RightShoulder");
	RightElbow = bodyparts.RightLowerArm:WaitForChild("RightElbow");
	RightWrist = bodyparts.RightHand:WaitForChild("RightWrist");
	
	Neck = bodyparts.Head:WaitForChild("Neck");
}

local constraints = {
	Ankle	= Instance.new("BallSocketConstraint");
	Elbow	= Instance.new("HingeConstraint");
	Hip		= Instance.new("BallSocketConstraint");
	Knee	= Instance.new("HingeConstraint");
	Neck	= Instance.new("BallSocketConstraint");
	Shoulder= Instance.new("BallSocketConstraint");
	Waist	= Instance.new("BallSocketConstraint");
	Wrist	= Instance.new("BallSocketConstraint"); 
}

constraints.Ankle.LimitsEnabled = true
constraints.Ankle.TwistLimitsEnabled = true
constraints.Ankle.UpperAngle = 30
constraints.Ankle.TwistLowerAngle = -45
constraints.Ankle.TwistUpperAngle = 30

constraints.Elbow.LowerAngle = 0
constraints.Elbow.UpperAngle = 135
constraints.Elbow.LimitsEnabled = true

constraints.Hip.LimitsEnabled = true
constraints.Hip.TwistLimitsEnabled = true
constraints.Hip.UpperAngle = 50
constraints.Hip.TwistLowerAngle = 100
constraints.Hip.TwistUpperAngle = -45

constraints.Knee.LowerAngle = -140
constraints.Knee.UpperAngle = 0
constraints.Knee.LimitsEnabled = true

constraints.Neck.LimitsEnabled = true
constraints.Neck.TwistLimitsEnabled = true
constraints.Neck.MaxFrictionTorque = 4
constraints.Neck.UpperAngle = 60
constraints.Neck.TwistLowerAngle = -75
constraints.Neck.TwistUpperAngle = 60

constraints.Shoulder.LimitsEnabled = true
constraints.Shoulder.TwistLimitsEnabled = true
constraints.Shoulder.UpperAngle = 45
constraints.Shoulder.TwistLowerAngle = -90
constraints.Shoulder.TwistUpperAngle = 150

constraints.Waist.LimitsEnabled = true
constraints.Waist.TwistLimitsEnabled = true
constraints.Waist.UpperAngle = 30
constraints.Waist.TwistLowerAngle = -55
constraints.Waist.TwistUpperAngle = 25

constraints.Wrist.LimitsEnabled = true
constraints.Wrist.TwistLimitsEnabled = true
constraints.Wrist.UpperAngle = 30
constraints.Wrist.TwistLowerAngle = -45
constraints.Wrist.TwistUpperAngle = 45

function toggleMotors(mode)
	for i,v in pairs(motors) do
		if i ~= "Root" then
			v.Enabled = mode
		end
	end
end

local orgrootmotor = motors.Root
local altrootmotor = Instance.new("Motor6D",bodyparts.UpperTorso)
altrootmotor.C0 = CFrame.new(0,(bodyparts.LowerTorso.Size.Y)*0.7,0)
altrootmotor.Enabled = false
altrootmotor.Part0 = bodyparts.HumanoidRootPart
altrootmotor.Part1 = bodyparts.UpperTorso

function ragdollJoint(part0, part1, attachmentName)
	local constraintname
	for i,v in pairs(constraints) do
		if string.match(attachmentName,i) then
			constraintname = i
			break
		end
	end
	attachmentName = attachmentName.."RigAttachment"
	local constraint = constraints[constraintname]:Clone()
	constraint.Attachment0 = part0[attachmentName]
	constraint.Attachment1 = part1[attachmentName]
	constraint.Name = "Ragdoll_"..part1.Name
	
	constraint.Parent = constraintfolder
end

pcall(ragdollJoint,bodyparts.LowerTorso, bodyparts.UpperTorso, "Waist")

pcall(ragdollJoint,bodyparts.UpperTorso, bodyparts.Head, "Neck")

pcall(ragdollJoint,bodyparts.UpperTorso, bodyparts.LeftUpperArm, "LeftShoulder")
pcall(ragdollJoint,bodyparts.UpperTorso, bodyparts.RightUpperArm, "RightShoulder")

pcall(ragdollJoint,bodyparts.LeftUpperArm, bodyparts.LeftLowerArm, "LeftElbow")
pcall(ragdollJoint,bodyparts.RightUpperArm, bodyparts.RightLowerArm, "RightElbow")

pcall(ragdollJoint,bodyparts.LeftLowerArm, bodyparts.LeftHand, "LeftWrist")
pcall(ragdollJoint,bodyparts.RightLowerArm, bodyparts.RightHand, "RightWrist")

pcall(ragdollJoint,bodyparts.LowerTorso, bodyparts.LeftUpperLeg, "LeftHip")
pcall(ragdollJoint,bodyparts.LowerTorso, bodyparts.RightUpperLeg, "RightHip")

pcall(ragdollJoint,bodyparts.LeftUpperLeg, bodyparts.LeftLowerLeg, "LeftKnee")
pcall(ragdollJoint,bodyparts.RightUpperLeg, bodyparts.RightLowerLeg, "RightKnee")

pcall(ragdollJoint,bodyparts.LeftLowerLeg, bodyparts.LeftFoot, "LeftAnkle")
pcall(ragdollJoint,bodyparts.RightLowerLeg, bodyparts.RightFoot, "RightAnkle")

function getAccessoryAttachment0(name)
	for _,v in pairs(character:GetChildren()) do
		local attachment = v:FindFirstChild(name)
		if attachment then return attachment end
	end
end

function makeaccessoryjoints()
	for _,v in pairs(character:GetChildren()) do
		if v:IsA("Accessory") then
			local handle = v:FindFirstChild("Handle")
			if handle then
				handle.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
				local attachment1 = handle:FindFirstChildOfClass("Attachment")
				local attachment0 = getAccessoryAttachment0(attachment1.Name)
				if attachment1 and attachment0 then
					local con = Instance.new("HingeConstraint")
					con.Name = "Accessory_"..v.Name
					con.Attachment0 = attachment0
					con.Attachment1 = attachment1
					con.LimitsEnabled = true
					con.UpperAngle = 0
					con.LowerAngle = 0
					con.Parent = constraintfolder
				end
			end
		end
	end
end

makeaccessoryjoints()

bodyparts.HumanoidRootPart.CanCollide = false
bodyparts.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
bodyparts.Head.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
bodyparts.Head.OriginalSize.Value = Vector3.new(1,1,1)
bodyparts.Head.Size = Vector3.new(bodyparts.Head.Size.Z,bodyparts.Head.Size.Y,bodyparts.Head.Size.Z)

local HeadCollision = Instance.new("Part",bodyparts.Head)
HeadCollision.Name = "HeadCollision"
HeadCollision.Transparency = 1
HeadCollision.Parent = bodyparts.Head
HeadCollision.Shape = Enum.PartType.Cylinder
local headsize = bodyparts.Head.Size
HeadCollision.Size = Vector3.new(headsize.Y,headsize.Z,headsize.Z)
HeadCollision.CanCollide = true
bodyparts.Head:GetPropertyChangedSignal("Size"):Connect(function()
	local headsize = bodyparts.Head.Size
	HeadCollision.Size = Vector3.new(headsize.Y,headsize.Z,headsize.Z)
end)

local HeadCollisionWeld = Instance.new("Weld",HeadCollision)
HeadCollisionWeld.Part0 = bodyparts.Head
HeadCollisionWeld.Part1 = HeadCollision
HeadCollisionWeld.C0 = HeadCollisionWeld.C0*CFrame.fromOrientation(0,0,math.rad(-90))

PhysicsService:SetPartCollisionGroup(bodyparts.Head,"noclip")

local HeadCollisionAttachment = Instance.new("Attachment",HeadCollision)
HeadCollisionAttachment.Orientation = Vector3.new(0,0,-90)

local HeadCollisionConstraint = Instance.new("HingeConstraint")
HeadCollisionConstraint.Name = "HeadCollision"
HeadCollisionConstraint.Attachment0 = bodyparts.Head.FaceCenterAttachment
HeadCollisionConstraint.Attachment1 = HeadCollisionAttachment
HeadCollisionConstraint.LimitsEnabled = true
HeadCollisionConstraint.UpperAngle = 0
HeadCollisionConstraint.LowerAngle = 0
HeadCollisionConstraint.Parent = constraintfolder

local collisionfiltertbl = {
	{
		HeadCollision;
		
		bodyparts.LeftUpperArm;
		bodyparts.LeftUpperLeg;
		bodyparts.LowerTorso;
		bodyparts.RightUpperArm;
		bodyparts.RightUpperLeg;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.LeftFoot;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	--[[{
		bodyparts.LeftHand;
		
		--bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};]]
	{
		bodyparts.LeftLowerArm;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.LeftLowerLeg;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.LeftUpperArm;
		
		bodyparts.LeftUpperLeg;
		bodyparts.LowerTorso;
		bodyparts.RightUpperArm;
		bodyparts.RightUpperLeg;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.LeftUpperLeg;
		
		bodyparts.LowerTorso;
		bodyparts.RightUpperLeg;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightFoot;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightHand;
		
		--bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightLowerArm;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightLowerLeg;
		
		bodyparts.LowerTorso;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightUpperArm;
		
		bodyparts.LeftUpperLeg;
		bodyparts.LowerTorso;
		bodyparts.LeftUpperArm;
		bodyparts.RightUpperLeg;
		bodyparts.UpperTorso;
	};
	{
		bodyparts.RightUpperLeg;
		
		bodyparts.LowerTorso;
		bodyparts.LeftUpperLeg;
		bodyparts.UpperTorso;
	};
}

function makecollisionfilters()
	for i=1,#collisionfiltertbl do
		for b=2,#collisionfiltertbl[i] do
			local constraint = Instance.new("NoCollisionConstraint",collisionfolder)
			constraint.Name = collisionfiltertbl[i][1].Name.."<->"..collisionfiltertbl[i][b].Name
			constraint.Part0 = collisionfiltertbl[i][1]
			constraint.Part1 = collisionfiltertbl[i][b]
		end
	end
end

makecollisionfilters()

local isragdollnow = false

function ragdoll(mode,velocity)
	if mode == true then
		if isragdollnow then if velocity then functions_remoteragdollvelocity:InvokeClient(player,velocity) end return end
		isragdollnow = true
		variables_ragdoll.Value = true
		altrootmotor.Enabled = true
		orgrootmotor.Enabled = false
		toggleMotors(false)
		functions_remoteragdoll:InvokeClient(player,true,velocity)
		--wait()
	elseif mode == "dead" then
		if flag_clonecharacter then
			player.CharacterRemoving:Connect(function()
				character.Archivable = true
				pcall(function() bodyparts.UpperTorso.radio.Sound:Destroy() end)
				local clone = character:Clone()
				clone.Name = player.Name.."'s Ragdoll"
				for _,v in pairs(clone:GetDescendants()) do
					if v:IsA("BaseScript") then
						v:Remove()
					end
				end
				for _,v in pairs(character:GetChildren()) do
					if not v:IsA("Humanoid") then
						v:Remove()
					end
				end
				clone.Parent = workspace
				clone.Humanoid.Health = 1
				clone.Humanoid.Health = 0
				if flag_autocleanup and flag_cleanuptime then
					Debris:AddItem(clone,flag_cleanuptime)
				end
				pcall(function()
					for _,v in pairs(clone:GetChildren()) do
						if v:IsA("BasePart") then
							v:SetNetworkOwnershipAuto()
						end
					end
				end)
			end)
		end
	else
		if not isragdollnow then return end
		isragdollnow = false
		orgrootmotor.Enabled = true
		altrootmotor.Enabled = false
		toggleMotors(true)
		functions_remoteragdoll:InvokeClient(player,false)
	end
end

humanoid.Died:Connect(function()
	ragdoll(true)
	ragdoll("dead")
end)

--variables_ragdoll:GetPropertyChangedSignal("Value"):Connect(function()
--	if humanoid.Health > 0 then ragdoll(variables_ragdoll.Value) ragdoll("dead") end
--end)

events_variableserver.OnServerEvent:Connect(function(plr,variable,mode)
	if variable == "reset" then
		humanoid.Health = 0
	else
		ragdoll(mode)
		ragdoll("dead")
		--pcall(function() variables[variable].Value = mode end)
	end 
end)

function functions_ragdoll.OnInvoke(velocity)
	ragdoll(true,velocity)
end

function functions_remoteragdoll.OnServerInvoke(plr)
	ragdoll(true)
end