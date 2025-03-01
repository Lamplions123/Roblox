local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local Worlds = {2753915549, 4442272183, 7449423635}

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local PositionY = 16
local TeleportsAreEnabled = false
local LeftShiftIsEnabled = false
local RightAltIsEnabled = false
local WalkingOnWaterIsEnabled = false

UserInputService.InputBegan:Connect(function(Input)
	if not LocalPlayer.Character then return end
	local Character = LocalPlayer.Character

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end


	if Input.KeyCode == Enum.KeyCode.LeftShift then
		if LeftShiftIsEnabled then
			HumanoidRootPart:ApplyImpulse(Camera.CFrame.LookVector * 5000)
			HumanoidRootPart:ApplyImpulse(Vector3.new(0, 1250, 0))
		end
	elseif Input.KeyCode == Enum.KeyCode.R then
		if TeleportsAreEnabled then
			Character:MoveTo(Mouse.Hit.Position)
		end
	elseif Input.KeyCode == Enum.KeyCode.RightAlt then	
		if RightAltIsEnabled then
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
	end
end)
--------------
local WaterBasePlane = workspace.Map:WaitForChild("WaterBase-Plane")

local WaterPart = WaterBasePlane:Clone()
WaterPart.Anchored = true
WaterPart.CanCollide = false
WaterPart.Transparency = 1
WaterPart.Parent = workspace

RunService.RenderStepped:Connect(function()
	if WalkingOnWaterIsEnabled then
		WaterPart.CanCollide = true
		if not LocalPlayer.Character then return end

		local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then return end

		WaterPart.Position = Vector3.new(HumanoidRootPart.Position.X, WaterBasePlane.Position.Y + PositionY, HumanoidRootPart.Position.Z)
	else
		WaterPart.CanCollide = false
	end
end)

--------

local function LoadGui()
	local CategoryY = 0
	
	local function SetUpGuiElement(Element: GuiBase, Properties: {any})
		
		if Element:IsA("TextButton") or Element:IsA("TextBox") then
			Element.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Element.BackgroundTransparency = 0.8
		else	
			Element.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		end
		
		if Element:IsA("Frame") or Element:IsA("ScrollingFrame") then
			Element.BorderSizePixel = 0
			Element.BackgroundTransparency = 1
			if Element:IsA("ScrollingFrame") then
				Element.AutomaticCanvasSize = Enum.AutomaticSize.Y
			end
		end
		
		if Element:IsA("ScrollingFrame") then
			Element.ScrollBarThickness = 0
		end
		
		if Element:IsA("TextLabel") or Element:IsA("TextButton") or Element:IsA("TextBox") then
			Element.TextScaled = true
			Element.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
		
		for Property, Value in Properties do
			if Property == "Size" or Property == "Position" then
				Element[Property] = UDim2.new(Value.X, 0, Value.Y, 0)
			elseif Property == "UICorner" then
				Instance.new("UICorner", Element).CornerRadius = UDim.new(0, Value)
			elseif Property == "UIDragDetector" then
				Instance.new("UIDragDetector", Element)
			else
				Element[Property] = Value
			end
		end
		
		return Element
	end
	
	local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
	ScreenGui.Name = "LGui"
	ScreenGui.ResetOnSpawn = false
	
	local MainFrame = SetUpGuiElement(Instance.new("Frame", ScreenGui), {
		Name = "MainFrame",
		Size = {X = 0.3, Y = 0.3}, 
		Position = {X = 0.25, Y = 0.25},
		BackgroundTransparency = 0.5,
		UICorner = 16,
		UIDragDetector = true,
		Visible = false
	})
	
	local ScrollingFrameFunctions = SetUpGuiElement(Instance.new("ScrollingFrame", MainFrame), {
		Name = "ScrollingFrameFunctions",
		Size = {X = 0.8, Y = 0.9},
		Position = {X = 0.2, Y = 0.05}
	})
	
	local ScrollingFrameCategories = SetUpGuiElement(Instance.new("ScrollingFrame", MainFrame), {
		Name = "ScrollingFrameCategories",
		Size = {X = 0.2, Y = 0.9},
		Position = {Y = 0.05}
	})
	
	local LButton = SetUpGuiElement(Instance.new("TextButton", ScreenGui), {
		Name = "LButton",
		Size = {X = 0.05, Y = 0.1},
		Text = "L",
		UICorner = 24
	})
	
	---
	local function CreateCategory(Name: string)
		local CategoryFrame = SetUpGuiElement(Instance.new("Frame", ScrollingFrameFunctions), {
			Name = Name.."Frame",
			Size = {X = 1, Y = 1},
			Visible = false
		})
		CategoryFrame:SetAttribute("Y", 0)
		
		local CategoryButton = SetUpGuiElement(Instance.new("TextButton", ScrollingFrameCategories), {
			Name = Name.."Button",
			Size = {X = 1, Y = 0.1},
			Position = {Y = CategoryY},
			Text = Name,
			UICorner = 16
		})
		CategoryY += 0.1
		
		CategoryButton.MouseButton1Click:Connect(function()
			for Index, Value in ScrollingFrameFunctions:GetChildren() do
				Value.Visible = false
			end
			CategoryFrame.Visible = true
		end)
		
		return Name
	end
	
	local function InsertElementInCategory(Element: string, Text: string, Category: string)
		local CategoryFrame: Frame = ScrollingFrameFunctions[Category.."Frame"]
		
		local Element = SetUpGuiElement(Instance.new(Element, CategoryFrame), {
			Name = Text,
			Text = Text,
			Size = {X = 1, Y = 0.2},
			Position = {Y = CategoryFrame:GetAttribute("Y")},
			UICorner = 16
		})
		CategoryFrame:SetAttribute("Y", CategoryFrame:GetAttribute("Y") + 0.2)
		
		if Element:IsA("TextButton") then
			Element:SetAttribute("Enabled", false)
			Element.MouseButton1Click:Connect(function()
				if Element.TextColor3 == Color3.fromRGB(255, 255, 255) then
					Element.TextColor3 = Color3.fromRGB(0, 255, 0)
					Element:SetAttribute("Enabled", true)
				else
					Element.TextColor3 = Color3.fromRGB(255, 255, 255)
					Element:SetAttribute("Enabled", false)
				end
			end)
		end
		
		return Element
	end
	
	
	
	--- Teleport Category
	local TeleportCategory = CreateCategory("Teleport 🌍")
	local RejoinTheServer = InsertElementInCategory("TextButton", "Rejoin the current server", TeleportCategory)
	for Index=1, #Worlds do
		local TeleportButton = InsertElementInCategory("TextButton", `Teleport to {Index} world`, TeleportCategory)
		
		TeleportButton.MouseButton1Click:Connect(function()
			TeleportService:Teleport(Worlds[Index], LocalPlayer)
		end)
	end
	
	RejoinTheServer.MouseButton1Click:Connect(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end)
	
	-- Movement Category
	local MovementCategory = CreateCategory("Movement 🏃‍")
	local EnableWalkingButton = InsertElementInCategory("TextButton", "Enable walking on water", MovementCategory)
	local SeaLevelButton = InsertElementInCategory("TextBox", "Write sea level here", MovementCategory)
	local EnableTeleportsButton = InsertElementInCategory("TextButton", "Enable teleports", MovementCategory)
	local LeftShiftButton = InsertElementInCategory("TextButton", "Enable Left Shift", MovementCategory)
	
	EnableWalkingButton.MouseButton1Click:Connect(function()
		task.wait()
		if EnableWalkingButton:GetAttribute("Enabled") then
			print("true")
			WalkingOnWaterIsEnabled = true
		else
			WalkingOnWaterIsEnabled = false
		end
	end)
	
	SeaLevelButton.FocusLost:Connect(function()
		if tonumber(SeaLevelButton.Text) then
			PositionY = SeaLevelButton.Text + 16
		else
			SeaLevelButton.Text = "Write Sea Level"
		end
	end)
	
	EnableTeleportsButton.MouseButton1Click:Connect(function()
		task.wait()
		if EnableTeleportsButton:GetAttribute("Enabled") then
			TeleportsAreEnabled = true
		else
			TeleportsAreEnabled = false
		end
	end)
	
	LeftShiftButton.MouseButton1Click:Connect(function()
		task.wait()
		if LeftShiftButton:GetAttribute("Enabled") then
			LeftShiftIsEnabled = true
		else
			LeftShiftIsEnabled = false
		end
	end)
	
	-- Other
	local OtherCategory = CreateCategory("Other 🤔")
	local RightAltButton = InsertElementInCategory("TextButton", "Enable Right Alt", OtherCategory)
	RightAltButton.MouseButton1Click:Connect(function()
		task.wait()
		if LeftShiftButton:GetAttribute("Enabled") then
			RightAltIsEnabled = true
		else
			RightAltIsEnabled = false
		end
	end)
	
	------
	LButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)
end

LoadGui()
