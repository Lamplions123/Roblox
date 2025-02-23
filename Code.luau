local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local World1 = 2753915549
local World2 = 4442272183
local World3 = 7449423635

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

UserInputService.InputBegan:Connect(function(Input)
	if not LocalPlayer.Character then return end
	
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character.HumanoidRootPart
	
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		HumanoidRootPart:ApplyImpulse(Camera.CFrame.LookVector * 2500)
		HumanoidRootPart:ApplyImpulse(Vector3.new(0, 1250, 0))
	elseif Input.KeyCode == Enum.KeyCode.R then
		Character:MoveTo(Mouse.Hit.Position)
	elseif Input.KeyCode == Enum.KeyCode.RightAlt then	
		local Parts = workspace:GetPartBoundsInBox(HumanoidRootPart.CFrame, Vector3.new(100, 100, 100))	
		for _, Object in Parts do
			if Object.Parent:FindFirstChild("Humanoid") then
				local NewCharacter = Object.Parent
				if NewCharacter ~= Character then
					NewCharacter.Humanoid:TakeDamage(NewCharacter.Humanoid.Health)
				end
			end
		end
	end
end)
--------------
local WaterPart = workspace.Map["WaterBase-Plane"]

local NewPart = WaterPart:Clone()
NewPart.CanTouch = true
NewPart.Parent = workspace
NewPart.Position = WaterPart.Position + Vector3.new(0, 16, 0)

RunService.RenderStepped:Connect(function()
	if not LocalPlayer.Character then return end
	if not LocalPlayer.Character.HumanoidRootPart then return end
	local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
	NewPart.Position = Vector3.new(HumanoidRootPart.Position.X, NewPart.Position.Y, HumanoidRootPart.Position.Z)
end)

print("i like commits123")
print("i very very like it")