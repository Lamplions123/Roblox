local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local IsRunning = false

local DefaultSpeed = Humanoid.WalkSpeed


UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		HumanoidRootPart:ApplyImpulse(Camera.CFrame.LookVector * 2500)
		HumanoidRootPart:ApplyImpulse(Vector3.new(0, 1250, 0))
	elseif Input.KeyCode == Enum.KeyCode.R then
		Character:MoveTo(Mouse.Hit.Position)
	end
end)

--------------
local WaterPart = workspace.Map["WaterBase-Plane"]

local NewPart = WaterPart:Clone()
NewPart.CanTouch = true
NewPart.Parent = workspace
NewPart.Position = WaterPart.Position + Vector3.new(0, 20, 0)

NewPart.Touched:Connect(function(Hit)
	if Hit.Parent:FindFirstChild("Humanoid") then
		local NewCharacter = Hit.Parent
		if NewCharacter == LocalPlayer.Character then
			
		end
	end
end)

Humanoid.Running:Connect(function(Speed)
	if Speed ~= 0 then
		IsRunning = true
	else
		IsRunning = false
	end
end)

RunService.RenderStepped:Connect(function()
	if IsRunning then
		NewPart.Position = Vector3.new(HumanoidRootPart.Position.X, NewPart.Position.Y, HumanoidRootPart.Position.Z)
	end
end)
