repeat wait() until script.Parent.Parent.Parent:IsA("Player")
repeat wait() until script.Parent.Parent.Parent.Character:FindFirstChild("Humanoid")

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local variables = script.Parent:WaitForChild("variables")
local variables_ragdoll = variables:WaitForChild("ragdoll")
local variables_ragdollonclient = variables:WaitForChild("ragdollonclient")

local events = script.Parent:WaitForChild("events")
local events_variableserver = events:WaitForChild("variableserver")
local events_resetclient = events:WaitForChild("resetclient")

local functions = script.Parent:WaitForChild("functions")
local functions_remoteragdoll = functions:WaitForChild("remoteragdoll")
local functions_remoteragdollvelocity = functions:WaitForChild("remoteragdollvelocity")

function killRagdoll(inst)
	if string.match(inst.Name,"'s Ragdoll") then
		local hum = inst:WaitForChild("Humanoid")
		hum.Health = 1
		hum.Health = 0
	end
end

for _,v in pairs(workspace:GetChildren()) do
	killRagdoll(v)
end

workspace.ChildAdded:Connect(function(child)
	killRagdoll(child)
end)

function functions_remoteragdoll.OnClientInvoke(mode,velocity)
	if mode then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		humanoid.AutoRotate = false
		pcall(function() character.Animate.Disabled = true end)
		for _,v in pairs(humanoid:GetPlayingAnimationTracks()) do --use this to prevent certain animations from stopping, anim names don't replicate through FE.
			if v.Name ~= "DummyAnim" and v.Animation.AnimationId ~= "rbxassetid://0" then
				v:Stop(0)
			end
		end
		if velocity then
			character.HumanoidRootPart.Velocity = velocity
		end
		variables_ragdollonclient.Value = true
	else
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		humanoid.AutoRotate = true
		pcall(function() character.Animate.Disabled = false end)
		variables_ragdollonclient.Value = false
		for _,v in pairs(character:GetChildren()) do
			if v:IsA("BasePart") then
				v.Velocity = Vector3.new(0,0,0)
				v.RotVelocity = Vector3.new(0,0,0)
			end
		end
	end
end


function functions_remoteragdollvelocity.OnClientInvoke(velocity)
	character.HumanoidRootPart.Velocity = velocity
end

game:GetService("ContextActionService"):BindAction("RagdollToggle", function(_,input)
	if input == Enum.UserInputState.Begin then
		variables_ragdoll.Value = not variables_ragdoll.Value
		events_variableserver:FireServer("ragdoll",variables_ragdoll.Value)
		if variables_ragdoll.Value == true then
			--game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Head")
		else
			--game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
		end
	end
end, true, Enum.KeyCode.R)

game:GetService("ContextActionService"):SetTitle("RagdollToggle", "Ragdoll")
game:GetService("ContextActionService"):SetPosition("RagdollToggle", UDim2.new(1, -110, 0, 15))

script.Parent.events.variableserver.OnClientEvent:Connect(function()
	events_variableserver:FireServer("ragdoll",variables_ragdoll.Value)
end)
--[[
game:GetService("ContextActionService"):BindAction("AntigravityToggle", function(_,input)
	if input == Enum.UserInputState.Begin then
		events_variableserver:FireServer("reset")
	end
end, false, Enum.KeyCode.Z)
--]]

--[[events_resetclient.Event:Connect(function()
	events_variableserver:FireServer("reset")
end)

local resetsuccess = false
repeat wait() resetsuccess = pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback",events_resetclient) end) until resetsuccess == true]]