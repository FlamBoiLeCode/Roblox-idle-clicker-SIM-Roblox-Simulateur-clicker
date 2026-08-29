-- ClickHandler.lua (StarterPlayerScripts) — DAY 6 : Click Animation
-- Contient : MVP + Upgrades + NumberFormatter + Click Animation (Feature 4.2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")  -- ⭐ NOUVEAU DAY 6
local NumberFormatter = require(ReplicatedStorage:WaitForChild("NumberFormatter"))

local player = Players.LocalPlayer
local clickEvent = ReplicatedStorage:WaitForChild("ClickEvent")
local upgradeEvent = ReplicatedStorage:WaitForChild("UpgradeEvent")
local upgradesOwnedEvent = ReplicatedStorage:WaitForChild("UpgradesOwnedEvent")
local upgradesData = ReplicatedStorage:WaitForChild("UpgradesData")
local clickResultEvent = ReplicatedStorage:WaitForChild("ClickResultEvent")  -- ⭐ NOUVEAU DAY 6

local playerGui = player:WaitForChild("PlayerGui")

local ownedUpgrades = {}

-- ===== ScreenGui principal =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickerUI"
screenGui.Parent = playerGui

-- ⭐ NOUVEAU DAY 6 : Fonction coin flottant "+X"
local function showFloatingCoin(amount)
    local floatLabel = Instance.new("TextLabel")
    floatLabel.Size = UDim2.new(0, 100, 0, 40)
    floatLabel.Position = UDim2.new(0.5, -50, 0.7, -20)
    floatLabel.Text = "+" .. NumberFormatter.format(amount)
    floatLabel.TextSize = 28
    floatLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
    floatLabel.BackgroundTransparency = 1
    floatLabel.Font = Enum.Font.GothamBold
    floatLabel.TextStrokeTransparency = 0.3
    floatLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    floatLabel.Parent = screenGui
    
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {
        Position = UDim2.new(0.5, -50, 0.5, -20),
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }
    
    local tween = TweenService:Create(floatLabel, tweenInfo, goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        floatLabel:Destroy()
    end)
end

-- ⭐ NOUVEAU DAY 6 : Écoute du gain envoyé par le serveur
clickResultEvent.OnClientEvent:Connect(function(amount)
    showFloatingCoin(amount)
end)

-- ===== BOUTON PRINCIPAL CLIQUER =====
local clickButton = Instance.new("TextButton")
clickButton.Size = UDim2.new(0, 250, 0, 100)
clickButton.Position = UDim2.new(0.5, -125, 0.7, 0)
clickButton.Text = "CLIQUER 💰"
clickButton.TextSize = 24
clickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clickButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
clickButton.BorderSizePixel = 0
clickButton.Font = Enum.Font.GothamBold
clickButton.Parent = screenGui

local clickCorner = Instance.new("UICorner")
clickCorner.CornerRadius = UDim.new(0, 12)
clickCorner.Parent = clickButton

-- ⭐ MODIFIÉ DAY 6 : Animation rebond smooth (shrink → grow avec effet Back)
clickButton.MouseButton1Click:Connect(function()
    clickEvent:FireServer()
    
    local shrinkTween = TweenService:Create(
        clickButton,
        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 235, 0, 92)}
    )
    local growTween = TweenService:Create(
        clickButton,
        TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 250, 0, 100)}
    )
    
    shrinkTween:Play()
    shrinkTween.Completed:Connect(function()
        growTween:Play()
    end)
end)

-- ===== BOUTON OUVRIR BOUTIQUE =====
local shopToggleButton = Instance.new("TextButton")
shopToggleButton.Size = UDim2.new(0, 150, 0, 50)
shopToggleButton.Position = UDim2.new(1, -170, 0.5, -25)
shopToggleButton.Text = "🛒 BOUTIQUE"
shopToggleButton.TextSize = 18
shopToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopToggleButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
shopToggleButton.BorderSizePixel = 0
shopToggleButton.Font = Enum.Font.GothamBold
shopToggleButton.Parent = screenGui

local shopToggleCorner = Instance.new("UICorner")
shopToggleCorner.CornerRadius = UDim.new(0, 10)
shopToggleCorner.Parent = shopToggleButton

-- ===== PANNEAU BOUTIQUE =====
local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 400, 0, 450)
shopFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.Parent = screenGui

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 12)
shopCorner.Parent = shopFrame

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 40)
shopTitle.Text = "🛒 BOUTIQUE UPGRADES"
shopTitle.TextSize = 22
shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
shopTitle.BackgroundTransparency = 1
shopTitle.Font = Enum.Font.GothamBold
shopTitle.Parent = shopFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = shopFrame

closeButton.MouseButton1Click:Connect(function()
    shopFrame.Visible = false
end)

shopToggleButton.MouseButton1Click:Connect(function()
    shopFrame.Visible = not shopFrame.Visible
end)

-- ===== CRÉER UNE LIGNE D'UPGRADE =====
local function createUpgradeRow(upgradeInfo, index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 70)
    row.Position = UDim2.new(0, 10, 0, 50 + (index - 1) * 75)
    row.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    row.BorderSizePixel = 0
    row.Parent = shopFrame
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.Text = upgradeInfo.DisplayName.Value
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row
    
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(0.35, 0, 0.7, 0)
    buyButton.Position = UDim2.new(0.62, 0, 0.15, 0)
    buyButton.Text = NumberFormatter.format(upgradeInfo.Cost.Value) .. " 💰"
    buyButton.TextSize = 14
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
    buyButton.BorderSizePixel = 0
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = row
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 6)
    buyCorner.Parent = buyButton
    
    local function updateAppearance()
        if ownedUpgrades[upgradeInfo.Name] then
            buyButton.Text = "✅ ACHETÉ"
            buyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            buyButton.Text = NumberFormatter.format(upgradeInfo.Cost.Value) .. " 💰"
            buyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
        end
    end
    
    updateAppearance()
    
    upgradesOwnedEvent.OnClientEvent:Connect(function(owned)
        ownedUpgrades = owned
        updateAppearance()
    end)
    
    buyButton.MouseButton1Click:Connect(function()
        if not ownedUpgrades[upgradeInfo.Name] then
            upgradeEvent:FireServer(upgradeInfo.Name)
        end
    end)
end

-- Attendre que TOUS les upgrades soient créés côté serveur
local UPGRADE_IDS = {"upgrade1", "upgrade2", "upgrade3", "upgrade4", "upgrade5"}
for _, upgradeId in ipairs(UPGRADE_IDS) do
    upgradesData:WaitForChild(upgradeId, 10)
end

task.wait(0.2)

for index, upgradeId in ipairs(UPGRADE_IDS) do
    local upgradeInfo = upgradesData:WaitForChild(upgradeId)
    createUpgradeRow(upgradeInfo, index)
end
