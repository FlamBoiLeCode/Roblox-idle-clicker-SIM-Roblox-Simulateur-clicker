-- PrestigeUI.lua V4.4 TikTok
-- LocalScript dans StarterPlayerScripts
-- Features : Base F3 + NumberFormatter (F4.1) + Sons (F4.3) + Tween UI scale+fade centre (F4.4)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local prestigeEvent = ReplicatedStorage:WaitForChild("PrestigeEvent")
local prestigeInfoEvent = ReplicatedStorage:WaitForChild("PrestigeInfoEvent")

local NumberFormatter = require(ReplicatedStorage:WaitForChild("NumberFormatter"))

local SoundsFolder = ReplicatedStorage:WaitForChild("Sounds")
local prestigeSound = SoundsFolder:WaitForChild("PrestigeSound")

local playerGui = player:WaitForChild("PlayerGui")

local PRESTIGE_THRESHOLD = 100000
local PRESTIGE_BONUS = 0.1

local currentPrestigePoints = 0
local currentMultiplier = 1

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrestigeUI"
screenGui.Parent = playerGui

-- Bouton PRESTIGE
local prestigeButton = Instance.new("TextButton")
prestigeButton.Size = UDim2.new(0, 150, 0, 50)
prestigeButton.Position = UDim2.new(1, -170, 0.5, 100)
prestigeButton.Text = "⭐ PRESTIGE"
prestigeButton.TextSize = 18
prestigeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
prestigeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 200)
prestigeButton.BorderSizePixel = 0
prestigeButton.Font = Enum.Font.GothamBold
prestigeButton.Parent = screenGui

local prestigeCorner = Instance.new("UICorner")
prestigeCorner.CornerRadius = UDim.new(0, 10)
prestigeCorner.Parent = prestigeButton

-- Panneau PRESTIGE
local prestigeFrame = Instance.new("Frame")
prestigeFrame.Size = UDim2.new(0, 400, 0, 300)
prestigeFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
prestigeFrame.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
prestigeFrame.BorderSizePixel = 0
prestigeFrame.Visible = false
prestigeFrame.Parent = screenGui

local prestigeFrameCorner = Instance.new("UICorner")
prestigeFrameCorner.CornerRadius = UDim.new(0, 12)
prestigeFrameCorner.Parent = prestigeFrame

-- F4.4 : ANIMATION SCALE + FADE (PRESTIGE) — depuis le centre
local prestigeIsOpen = false
local ORIGINAL_SIZE = prestigeFrame.Size
local ORIGINAL_POS = prestigeFrame.Position

local function openPrestige()
	prestigeFrame.Size = UDim2.new(0, 0, 0, 0)
	prestigeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	prestigeFrame.BackgroundTransparency = 1
	prestigeFrame.Visible = true

	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	TweenService:Create(prestigeFrame, tweenInfo, {
		Size = ORIGINAL_SIZE,
		Position = ORIGINAL_POS,
		BackgroundTransparency = 0
	}):Play()

	prestigeIsOpen = true
end

local function closePrestige()
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local tween = TweenService:Create(prestigeFrame, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1
	})
	tween:Play()

	tween.Completed:Connect(function()
		prestigeFrame.Visible = false
	end)

	prestigeIsOpen = false
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⭐ PRESTIGE SYSTEM"
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = prestigeFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = prestigeFrame

-- F4.4 : close via animation
closeBtn.MouseButton1Click:Connect(function()
	closePrestige()
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 60)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.TextSize = 14
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Parent = prestigeFrame

local gainLabel = Instance.new("TextLabel")
gainLabel.Size = UDim2.new(1, -20, 0, 40)
gainLabel.Position = UDim2.new(0, 10, 0, 120)
gainLabel.TextSize = 18
gainLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
gainLabel.BackgroundTransparency = 1
gainLabel.Font = Enum.Font.GothamBold
gainLabel.Parent = prestigeFrame

local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(1, -20, 0, 30)
warning.Position = UDim2.new(0, 10, 0, 170)
warning.Text = "⚠️ RESET TOTAL : coins, upgrades, générateurs"
warning.TextSize = 12
warning.TextColor3 = Color3.fromRGB(255, 150, 150)
warning.BackgroundTransparency = 1
warning.Font = Enum.Font.Gotham
warning.Parent = prestigeFrame

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 200, 0, 50)
confirmBtn.Position = UDim2.new(0.5, -100, 1, -70)
confirmBtn.Text = "⭐ PRESTIGE MAINTENANT"
confirmBtn.TextSize = 16
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 200)
confirmBtn.BorderSizePixel = 0
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.Parent = prestigeFrame

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 8)
confirmCorner.Parent = confirmBtn

local coins = player:WaitForChild("leaderstats"):WaitForChild("Coins")

local function updateInfo()
	infoLabel.Text = "⭐ Points actuels : " .. currentPrestigePoints ..
		"\n📈 Multiplier actuel : x" .. string.format("%.1f", currentMultiplier)

	local pointsToGain = math.floor(coins.Value / PRESTIGE_THRESHOLD)
	if pointsToGain > 0 then
		gainLabel.Text = "🎁 Tu gagnerais : +" .. pointsToGain .. " points"
		confirmBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 200)
	else
		gainLabel.Text = "⛔ Pas assez de coins (min : " .. NumberFormatter.format(PRESTIGE_THRESHOLD) .. ")"
		confirmBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end
end

coins:GetPropertyChangedSignal("Value"):Connect(function()
	if prestigeFrame.Visible then
		updateInfo()
	end
end)

-- F4.4 : toggle avec animation
prestigeButton.MouseButton1Click:Connect(function()
	if prestigeIsOpen then
		closePrestige()
	else
		updateInfo()
		openPrestige()
	end
end)

-- F4.4 : confirmBtn utilise closePrestige au lieu de Visible=false
confirmBtn.MouseButton1Click:Connect(function()
	local pointsToGain = math.floor(coins.Value / PRESTIGE_THRESHOLD)
	if pointsToGain > 0 then
		prestigeEvent:FireServer()
		prestigeSound:Play()
		closePrestige()
	end
end)

prestigeInfoEvent.OnClientEvent:Connect(function(points, multiplier)
	currentPrestigePoints = points
	currentMultiplier = multiplier
	if prestigeFrame.Visible then
		updateInfo()
	end
end)
