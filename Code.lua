return(function(Number: number)
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
	NewPart.Position = WaterPart.Position + Vector3.new(0, Number, 0)

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
end)
