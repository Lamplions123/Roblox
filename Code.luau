local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local World1 = 2753915549
local World2 = 4442272183
local World3 = 7449423635

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local PositionY = 16

UserInputService.InputBegan:Connect(function(Input)
	if not LocalPlayer.Character then return end
	local Character = LocalPlayer.Character
	
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end


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
local WaterBasePlane = workspace.Map:WaitForChild("WaterBase-Plane")

local WaterPart = WaterBasePlane:Clone()
WaterPart.Parent = workspace

RunService.RenderStepped:Connect(function()
	if not LocalPlayer.Character then return end
	
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end
	
	WaterPart.Position = Vector3.new(HumanoidRootPart.Position.X, WaterBasePlane.Position.Y + PositionY, HumanoidRootPart.Position.Z)
end)

---------
local function LoadGui()
	local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
	ScreenGui.ResetOnSpawn = false

	local TextBox = Instance.new("TextBox", ScreenGui)
	TextBox.Size = UDim2.new(0.1, 0, 0.05, 0)
	TextBox.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextScaled = true
	TextBox.FocusLost:Connect(function()
		if tonumber(TextBox.Text) then
			if TextBox.Text == 0 then
				WaterPart.Transparency = 1
			else
				WaterPart.Transparency = 0.9
			end
			PositionY = TextBox.Text + 16
		else
			TextBox.Text = "Write only numbers!"
		end
	end)
	TextBox.Text = "0"
	local UICorner = Instance.new("UICorner", TextBox)
	UICorner.CornerRadius = UDim.new(0, 16)

	local TextButton = Instance.new("TextButton", ScreenGui)
	TextButton.Size = UDim2.new(0.1, 0, 0.05, 0)
	TextButton.Position = UDim2.new(0, 0, 0.075, 0)
	TextButton.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextScaled = true
	TextButton.Text = "Rejoin the current server"
	TextButton.MouseButton1Click:Connect(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end)
	local UICorner = Instance.new("UICorner", TextButton)
	UICorner.CornerRadius = UDim.new(0, 16)
end

LoadGui()
