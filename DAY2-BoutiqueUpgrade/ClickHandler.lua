-- ClickHandler.lua (StarterPlayerScripts) — VERSION AVEC BOUTIQUE
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local clickEvent = ReplicatedStorage:WaitForChild("ClickEvent")
local upgradeEvent = ReplicatedStorage:WaitForChild("UpgradeEvent")
local upgradesOwnedEvent = ReplicatedStorage:WaitForChild("UpgradesOwnedEvent")
local upgradesData = ReplicatedStorage:WaitForChild("UpgradesData")

local playerGui = player:WaitForChild("PlayerGui")

-- Stocker les upgrades déjà achetées
local ownedUpgrades = {}

-- ===== ScreenGui principal =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickerUI"
screenGui.Parent = playerGui

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

clickButton.MouseButton1Click:Connect(function()
    clickEvent:FireServer()
    clickButton.Size = UDim2.new(0, 240, 0, 95)
    task.wait(0.05)
    clickButton.Size = UDim2.new(0, 250, 0, 100)
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

-- ===== PANNEAU BOUTIQUE (caché par défaut) =====
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

-- Titre boutique
local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 40)
shopTitle.Text = "🛒 BOUTIQUE UPGRADES"
shopTitle.TextSize = 22
shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
shopTitle.BackgroundTransparency = 1
shopTitle.Font = Enum.Font.GothamBold
shopTitle.Parent = shopFrame

-- Bouton fermer boutique
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
    
    -- Nom de l'upgrade
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 0, 30)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.Text = upgradeInfo.DisplayName.Value  -- ⚠️ .DisplayName pas .Name (voir fix Main.lua)
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row
    
    -- Bonus
    local bonusLabel = Instance.new("TextLabel")
    bonusLabel.Size = UDim2.new(0.5, 0, 0, 25)
    bonusLabel.Position = UDim2.new(0, 10, 0, 35)
    bonusLabel.Text = "+" .. upgradeInfo.Bonus.Value .. " coins/clic"
    bonusLabel.TextSize = 13
    bonusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    bonusLabel.BackgroundTransparency = 1
    bonusLabel.Font = Enum.Font.Gotham
    bonusLabel.TextXAlignment = Enum.TextXAlignment.Left
    bonusLabel.Parent = row
    
    -- Bouton acheter
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(0, 120, 0, 40)
    buyButton.Position = UDim2.new(1, -130, 0.5, -20)
    buyButton.Text = upgradeInfo.Cost.Value .. " 💰"
    buyButton.TextSize = 14
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
    buyButton.BorderSizePixel = 0
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = row
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 6)
    buyCorner.Parent = buyButton
    
    -- Mettre à jour l'apparence selon si acheté ou non
    local function updateAppearance()
        if ownedUpgrades[upgradeInfo.Name] then
            buyButton.Text = "✅ ACHETÉ"
            buyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            buyButton.Text = upgradeInfo.Cost.Value .. " 💰"
            buyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
        end
    end
    
    updateAppearance()
    
    -- Écouter les changements
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

-- Créer les lignes d'upgrades
local upgradeChildren = upgradesData:GetChildren()
for i, upgradeInfo in ipairs(upgradeChildren) do
    createUpgradeRow(upgradeInfo, i)
end

-- Récupérer les upgrades déjà achetées au chargement
upgradesOwnedEvent.OnClientEvent:Connect(function(owned)
    ownedUpgrades = owned
end)
