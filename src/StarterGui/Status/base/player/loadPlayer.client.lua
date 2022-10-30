local players = game.Players
local player = players.LocalPlayer
local frame = script.Parent
local char = players:CreateHumanoidModelFromUserId(player.UserId)
local humanoid:Humanoid = char.Humanoid

-- Put character into frame
char.Parent = frame.wm
humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
char:PivotTo(CFrame.Angles(0, math.rad(180), 0))

-- Create camera
local cam:Camera = Instance.new("Camera", frame.wm)
frame.CurrentCamera = cam
cam.CFrame = CFrame.new(Vector3.new(char.Head.Position.X, char.Head.Position.Y, char.Head.Position.Z+2))
cam.CameraType = Enum.CameraType.Watch
cam.CameraSubject = char.Head

frame.Parent.Parent.Enabled = true