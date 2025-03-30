task.wait()
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Teams = game:GetService("Teams")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local BloxFruitWorlds = {2753915549, 4442272183, 7449423635}

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local WaterPositionY = 16
local ImpulseHorizontalSpeed = 5000
local ImpulseVerticalSpeed = 1250
local TeleportsAreEnabled = false
local LeftShiftIsEnabled = false
local RightAltIsEnabled = false
local WalkingOnWaterIsEnabled = false

local GameName

local function ShowMainFrame()
	local MainFrame = LocalPlayer.PlayerGui:FindFirstChild("LGui").MainFrame
	if not MainFrame then return end
	MainFrame.Visible = not MainFrame.Visible
end

local function GetOneNumber(Number: number)
	return string.format("%0.1f", Number)
end

local function GetLatestCharacterAndHumanoid()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character.Humanoid
	return Character, Humanoid
end

UserInputService.InputBegan:Connect(function(Input, Proc)
	if Proc then return end
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end

	if Input.KeyCode == Enum.KeyCode.LeftShift then
		if not LeftShiftIsEnabled then return end
		HumanoidRootPart:ApplyImpulse(Camera.CFrame.LookVector * ImpulseHorizontalSpeed)
		HumanoidRootPart:ApplyImpulse(Vector3.new(0, ImpulseVerticalSpeed, 0))
	elseif Input.KeyCode == Enum.KeyCode.Y then
		if not TeleportsAreEnabled then return end
		Character:MoveTo(Mouse.Hit.Position)
	elseif Input.KeyCode == Enum.KeyCode.RightAlt then	
		if not RightAltIsEnabled then return end
		local Parts = workspace:GetPartBoundsInBox(HumanoidRootPart.CFrame, Vector3.new(100, 100, 100))	
		for _, Object in Parts do
			if not Object.Parent:FindFirstChild("Humanoid") then continue end
			local NewCharacter = Object.Parent
			if NewCharacter == Character then return end
			NewCharacter.Humanoid:TakeDamage(NewCharacter.Humanoid.Health)
		end
	elseif Input.KeyCode == Enum.KeyCode.X then ShowMainFrame() end
end)
--------------
local WaterPart
local WaterBasePlane

if game.PlaceId == BloxFruitWorlds[1] or game.PlaceId == BloxFruitWorlds[2] or game.PlaceId == BloxFruitWorlds[3] then
	GameName = "BloxFruit"
end

if GameName == "BloxFruit" then
	WaterBasePlane = workspace.Map:WaitForChild("WaterBase-Plane")
	WaterPart = WaterBasePlane:Clone()
	WaterPart.Anchored = true
	WaterPart.CanCollide = false
	WaterPart.Transparency = 1
	WaterPart.Parent = workspace	
end

RunService.RenderStepped:Connect(function()
	if GameName ~= "BloxFruit" then return end
	if not WaterBasePlane then return end
	if not WaterPart then return end
	if WalkingOnWaterIsEnabled then
		WaterPart.CanCollide = true
		if not LocalPlayer.Character then return end

		local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then return end

		WaterPart.Position = Vector3.new(HumanoidRootPart.Position.X, WaterBasePlane.Position.Y + WaterPositionY, HumanoidRootPart.Position.Z)
	else
		WaterPart.CanCollide = false
	end
end)

--------

local LightingFolder = Instance.new("Folder")
LightingFolder.Parent = ReplicatedStorage
LightingFolder.Name = "LightingFolder"

local function LoadGui()
	local CategoryY = 0

	local function SetUpGuiElement(Element: GuiBase, Properties: {any})

		if Element:IsA("TextButton") or Element:IsA("TextBox") or Element:IsA("TextLabel") then
			Element.TextScaled = true
			Element.TextColor3 = Color3.fromRGB(255, 255, 255)
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
				Element.ScrollBarThickness = 0
			end
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
		Visible = false,
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

	local Bar = SetUpGuiElement(Instance.new("Frame", MainFrame), {
		Name = "Bar",
		Size = {X = 0.005, Y = 1},
		Position = {X = 0.2},
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0
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
			Size = {X = 1, Y = 0.2},
			Position = {Y = CategoryY},
			Text = Name,
			UICorner = 16
		})
		CategoryY += 0.25

		CategoryButton.MouseButton1Click:Connect(function()
			for Index, Value in ScrollingFrameFunctions:GetChildren() do
				Value.Visible = false
			end
			CategoryFrame.Visible = true
		end)

		return CategoryFrame
	end

	local function InsertElementInCategory(Element: string, Text: string, Category: Frame, DontChangeColor: boolean, TextColor3: Color3)
		local Element = SetUpGuiElement(Instance.new(Element, Category), {
			Name = Text,
			Text = Text,
			Size = {X = 1, Y = 0.2},
			Position = {Y = Category:GetAttribute("Y")},
			UICorner = 16
		})
		if TextColor3 then Element.TextColor3 = TextColor3 end
		Category:SetAttribute("Y", Category:GetAttribute("Y") + 0.25)

		if Element:IsA("TextButton") then
			Element:SetAttribute("Enabled", false)
			Element.MouseButton1Click:Connect(function()			
				if DontChangeColor then return end
				if Element:GetAttribute("Enabled") then
					Element.TextColor3 = Color3.fromRGB(255, 255, 255)
					Element:SetAttribute("Enabled", false)
				else
					Element.TextColor3 = Color3.fromRGB(0, 255, 0)
					Element:SetAttribute("Enabled", true)
				end
			end)
		end

		return Element
	end

	-- Movement Category
	local MovementCategory = CreateCategory("Movement 🏃‍")
	if GameName == "BloxFruit" then
		local EnableWalkingButton = InsertElementInCategory("TextButton", "Enable walking on water", MovementCategory)
		local SeaLevelButton = InsertElementInCategory("TextBox", `Sea level, {WaterPositionY - 16}`, MovementCategory)

		EnableWalkingButton.MouseButton1Click:Connect(function()
			task.wait()
			if EnableWalkingButton:GetAttribute("Enabled") then
				WalkingOnWaterIsEnabled = true
			else
				WalkingOnWaterIsEnabled = false
			end
		end)

		SeaLevelButton.FocusLost:Connect(function()
			if tonumber(SeaLevelButton.Text) then
				WaterPositionY = SeaLevelButton.Text + 16
			end
			SeaLevelButton.Text = `Sea level, {WaterPositionY - 16}`
		end)
	end

	local EnableTeleportsButton = InsertElementInCategory("TextButton", "Enable teleports ", MovementCategory)
	local LeftShiftButton = InsertElementInCategory("TextButton", "Enable Left Shift", MovementCategory)
	local ImpulseVerticalSpeedBox = InsertElementInCategory("TextBox", `Impulse vertical speed, {ImpulseVerticalSpeed}`, MovementCategory)
	local ImpulseHorizontalSpeedBox = InsertElementInCategory("TextBox", `Impulse horizontal speed, {ImpulseHorizontalSpeed}`, MovementCategory)

	ImpulseVerticalSpeedBox.FocusLost:Connect(function()
		if tonumber(ImpulseVerticalSpeedBox.Text) then
			ImpulseVerticalSpeed = ImpulseVerticalSpeedBox.Text
		end
		ImpulseVerticalSpeedBox.Text = `Impulse vertical speed, {ImpulseVerticalSpeed}`
	end)

	ImpulseHorizontalSpeedBox.FocusLost:Connect(function()
		if tonumber(ImpulseHorizontalSpeedBox.Text) then
			ImpulseHorizontalSpeed = ImpulseHorizontalSpeedBox.Text
		end
		ImpulseHorizontalSpeedBox.Text = `Impulse horizontal speed, {ImpulseHorizontalSpeed}`
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

	-- Teams
	if #Teams:GetTeams() ~= 0 then
		local TeamsCategory = CreateCategory("Teams 🔴🔵")
		for Index, Value in Teams:GetTeams() do
			local TeamButton = InsertElementInCategory("TextButton", Value.Name, TeamsCategory, true, Value.TeamColor.Color)
			TeamButton.MouseButton1Click:Connect(function()
				LocalPlayer.Team = Value
			end)
		end
	end

	-- Other
	local OtherCategory = CreateCategory("Other 🤔")
	local RightAltButton = InsertElementInCategory("TextButton", "Enable Right Alt", OtherCategory)
	local LightingButton = InsertElementInCategory("TextButton", "Enable Lighting", OtherCategory)
	local RejoinTheServer = InsertElementInCategory("TextButton", "Rejoin the current server", OtherCategory, true)

	RejoinTheServer.MouseButton1Click:Connect(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end)
	
	RightAltButton.MouseButton1Click:Connect(function()
		task.wait()
		if LeftShiftButton:GetAttribute("Enabled") then
			RightAltIsEnabled = true
		else
			RightAltIsEnabled = false
		end
	end)
	
	LightingButton.MouseButton1Click:Connect(function()
		if #LightingFolder:GetChildren() == 0 then
			for Index, Value in Lighting:GetChildren() do
				Value.Parent = LightingFolder
			end
		else
			for Index, Value in LightingFolder:GetChildren() do
				Value.Parent = Lighting
			end 
		end
	end)
	
	if GameName == "BloxFruit" then
		local WaterTransparencyBox = InsertElementInCategory("TextBox", `Water transparency, {WaterPart.Transparency}`, OtherCategory)
		WaterTransparencyBox.FocusLost:Connect(function()
			if tonumber(WaterTransparencyBox.Text) then
				WaterPart.Transparency = WaterTransparencyBox.Text
			end
			WaterTransparencyBox.Text = `Water transparency, {GetOneNumber(WaterPart.Transparency)}`
		end)
	end
end

LoadGui()
