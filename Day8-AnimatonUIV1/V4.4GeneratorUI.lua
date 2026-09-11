-- GeneratorsUI.lua V4.4 TikTok
-- LocalScript dans StarterPlayerScripts
-- Features : Base F2 + NumberFormatter (F4.1) + Sons (F4.3) + Tween UI slide gauche (F4.4)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local buyGeneratorEvent = ReplicatedStorage:WaitForChild("BuyGeneratorEvent")
local generatorsOwnedEvent = ReplicatedStorage:WaitForChild("GeneratorsOwnedEvent")
local generatorsData = ReplicatedStorage:WaitForChild("GeneratorsData")

local NumberFormatter = require(ReplicatedStorage:WaitForChild("NumberFormatter"))

local SoundsFolder = ReplicatedStorage:WaitForChild("Sounds")
local purchaseSound = SoundsFolder:WaitForChild("PurchaseSound")

local playerGui = player:WaitForChild("PlayerGui")

local GENERATOR_IDS = {"gen1", "gen2", "gen3", "gen4", "gen5"}
for _, genId in ipairs(GENERATOR_IDS) do
	generatorsData:WaitForChild(genId, 10)
end

task.wait(0.2)

local COST_MULTIPLIER = 1.15
local ownedGenerators = {}
local rowsUpdaters = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeneratorsUI"
screenGui.Parent = playerGui

-- Bouton OUVRIR GÉNÉRATEURS
local genToggleButton = Instance.new("TextButton")
genToggleButton.Size = UDim2.new(0, 150, 0, 50)
genToggleButton.Position = UDim2.new(1, -170, 0.5, 40)
genToggleButton.Text = "🏭 GÉNÉRATEURS"
genToggleButton.TextSize = 16
genToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
genToggleButton.BackgroundColor3 = Color3.fromRGB(80, 100, 200)
genToggleButton.BorderSizePixel = 0
genToggleButton.Font = Enum.Font.GothamBold
genToggleButton.Parent = screenGui

local genToggleCorner = Instance.new("UICorner")
genToggleCorner.CornerRadius = UDim.new(0, 10)
genToggleCorner.Parent = genToggleButton

-- Panneau GÉNÉRATEURS
local genFrame = Instance.new("Frame")
genFrame.Size = UDim2.new(0, 450, 0, 500)
genFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
genFrame.BorderSizePixel = 0
genFrame.Parent = screenGui

local genCorner = Instance.new("UICorner")
genCorner.CornerRadius = UDim.new(0, 12)
genCorner.Parent = genFrame

-- F4.4 : ANIMATION SLIDE PANEL (GÉNÉRATEURS) — depuis la gauche
local genIsOpen = false
local GEN_CLOSED_POS = UDim2.new(0, -500, 0.5, -250)    -- hors écran gauche
local GEN_OPEN_POS = UDim2.new(0.5, -225, 0.5, -250)    -- centré

genFrame.Position = GEN_CLOSED_POS
genFrame.Visible = true

local function toggleGen()
	local targetPos = genIsOpen and GEN_CLOSED_POS or GEN_OPEN_POS
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	TweenService:Create(genFrame, tweenInfo, {Position = targetPos}):Play()
	genIsOpen = not genIsOpen
end

local genTitle = Instance.new("TextLabel")
genTitle.Size = UDim2.new(1, 0, 0, 40)
genTitle.Text = "🏭 GÉNÉRATEURS PASSIFS"
genTitle.TextSize = 22
genTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
genTitle.BackgroundTransparency = 1
genTitle.Font = Enum.Font.GothamBold
genTitle.Parent = genFrame

local coinsPerSecLabel = Instance.new("TextLabel")
coinsPerSecLabel.Size = UDim2.new(1, -20, 0, 30)
coinsPerSecLabel.Position = UDim2.new(0, 10, 0, 45)
coinsPerSecLabel.Text = "💰 0 coins/sec"
coinsPerSecLabel.TextSize = 16
coinsPerSecLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
coinsPerSecLabel.BackgroundTransparency = 1
coinsPerSecLabel.Font = Enum.Font.GothamBold
coinsPerSecLabel.Parent = genFrame

local closeGenButton = Instance.new("TextButton")
closeGenButton.Size = UDim2.new(0, 30, 0, 30)
closeGenButton.Position = UDim2.new(1, -35, 0, 5)
closeGenButton.Text = "X"
closeGenButton.TextSize = 18
closeGenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeGenButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeGenButton.BorderSizePixel = 0
closeGenButton.Font = Enum.Font.GothamBold
closeGenButton.Parent = genFrame

-- F4.4 : close via animation
closeGenButton.MouseButton1Click:Connect(function()
	if genIsOpen then toggleGen() end
end)

genToggleButton.MouseButton1Click:Connect(function()
	toggleGen()
end)

local function updateTotalCoinsPerSec()
	local total = 0
	for _, genInfo in ipairs(generatorsData:GetChildren()) do
		local count = ownedGenerators[genInfo.Name] or 0
		total = total + (count * genInfo.CoinsPerSec.Value)
	end
	coinsPerSecLabel.Text = "💰 " .. NumberFormatter.format(total) .. " coins/sec"
end

local function createGeneratorRow(genInfo, index)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 75)
	row.Position = UDim2.new(0, 10, 0, 85 + (index - 1) * 80)
	row.BackgroundColor3 = Color3.fromRGB(60, 70, 110)
	row.BorderSizePixel = 0
	row.Parent = genFrame

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 8)
	rowCorner.Parent = row

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.55, 0, 0, 25)
	nameLabel.Position = UDim2.new(0, 10, 0, 5)
	nameLabel.Text = genInfo.DisplayName.Value
	nameLabel.TextSize = 16
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = row

	local prodLabel = Instance.new("TextLabel")
	prodLabel.Size = UDim2.new(0.55, 0, 0, 20)
	prodLabel.Position = UDim2.new(0, 10, 0, 30)
	prodLabel.Text = "+" .. NumberFormatter.format(genInfo.CoinsPerSec.Value) .. " coins/sec"
	prodLabel.TextSize = 12
	prodLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
	prodLabel.BackgroundTransparency = 1
	prodLabel.Font = Enum.Font.Gotham
	prodLabel.TextXAlignment = Enum.TextXAlignment.Left
	prodLabel.Parent = row

	local ownedLabel = Instance.new("TextLabel")
	ownedLabel.Size = UDim2.new(0.55, 0, 0, 20)
	ownedLabel.Position = UDim2.new(0, 10, 0, 50)
	ownedLabel.Text = "Possédé : 0"
	ownedLabel.TextSize = 12
	ownedLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
	ownedLabel.BackgroundTransparency = 1
	ownedLabel.Font = Enum.Font.Gotham
	ownedLabel.TextXAlignment = Enum.TextXAlignment.Left
	ownedLabel.Parent = row

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 130, 0, 45)
	buyButton.Position = UDim2.new(1, -140, 0.5, -22)
	buyButton.TextSize = 14
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
	buyButton.BorderSizePixel = 0
	buyButton.Font = Enum.Font.GothamBold
	buyButton.Parent = row

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	local function updateRow()
		local owned = ownedGenerators[genInfo.Name] or 0
		local currentCost = math.floor(genInfo.BaseCost.Value * (COST_MULTIPLIER ^ owned))
		buyButton.Text = NumberFormatter.format(currentCost) .. " 💰"
		ownedLabel.Text = "Possédé : " .. owned
	end

	updateRow()
	rowsUpdaters[genInfo.Name] = updateRow

	buyButton.MouseButton1Click:Connect(function()
		buyGeneratorEvent:FireServer(genInfo.Name)
		purchaseSound:Play()
	end)
end

generatorsOwnedEvent.OnClientEvent:Connect(function(owned)
	ownedGenerators = owned
	for _, updater in pairs(rowsUpdaters) do
		updater()
	end
	updateTotalCoinsPerSec()
end)

for i, genId in ipairs(GENERATOR_IDS) do
	local genInfo = generatorsData:FindFirstChild(genId)
	if genInfo then
		createGeneratorRow(genInfo, i)
	end
end

updateTotalCoinsPerSec()
