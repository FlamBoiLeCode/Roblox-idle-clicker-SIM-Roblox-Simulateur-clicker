-- GeneratorsUI.lua (StarterPlayerScripts) — UI Générateurs Feature 2
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local buyGeneratorEvent = ReplicatedStorage:WaitForChild("BuyGeneratorEvent")
local generatorsOwnedEvent = ReplicatedStorage:WaitForChild("GeneratorsOwnedEvent")
local generatorsData = ReplicatedStorage:WaitForChild("GeneratorsData")

local playerGui = player:WaitForChild("PlayerGui")

-- Attendre que TOUS les generators soient créés côté serveur
local GENERATOR_IDS = {"gen1", "gen2", "gen3", "gen4", "gen5"}
for _, genId in ipairs(GENERATOR_IDS) do
    generatorsData:WaitForChild(genId, 10)
end

task.wait(0.2)

local COST_MULTIPLIER = 1.15
local ownedGenerators = {}
local rowsUpdaters = {}  -- pour rafraîchir les rows quand achat

-- ===== ScreenGui séparé =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeneratorsUI"
screenGui.Parent = playerGui

-- ===== BOUTON OUVRIR GÉNÉRATEURS =====
local genToggleButton = Instance.new("TextButton")
genToggleButton.Size = UDim2.new(0, 150, 0, 50)
genToggleButton.Position = UDim2.new(1, -170, 0.5, 40)  -- juste sous le bouton Boutique
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

-- ===== PANNEAU GÉNÉRATEURS (caché par défaut) =====
local genFrame = Instance.new("Frame")
genFrame.Size = UDim2.new(0, 450, 0, 500)
genFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
genFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
genFrame.BorderSizePixel = 0
genFrame.Visible = false
genFrame.Parent = screenGui

local genCorner = Instance.new("UICorner")
genCorner.CornerRadius = UDim.new(0, 12)
genCorner.Parent = genFrame

-- Titre panneau
local genTitle = Instance.new("TextLabel")
genTitle.Size = UDim2.new(1, 0, 0, 40)
genTitle.Text = "🏭 GÉNÉRATEURS PASSIFS"
genTitle.TextSize = 22
genTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
genTitle.BackgroundTransparency = 1
genTitle.Font = Enum.Font.GothamBold
genTitle.Parent = genFrame

-- Affichage coins/sec total (mis à jour dynamiquement)
local coinsPerSecLabel = Instance.new("TextLabel")
coinsPerSecLabel.Size = UDim2.new(1, -20, 0, 30)
coinsPerSecLabel.Position = UDim2.new(0, 10, 0, 45)
coinsPerSecLabel.Text = "💰 0 coins/sec"
coinsPerSecLabel.TextSize = 16
coinsPerSecLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
coinsPerSecLabel.BackgroundTransparency = 1
coinsPerSecLabel.Font = Enum.Font.GothamBold
coinsPerSecLabel.Parent = genFrame

-- Bouton fermer
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

closeGenButton.MouseButton1Click:Connect(function()
    genFrame.Visible = false
end)

genToggleButton.MouseButton1Click:Connect(function()
    genFrame.Visible = not genFrame.Visible
end)

-- ===== FONCTION : mettre à jour l'affichage coins/sec total =====
local function updateTotalCoinsPerSec()
    local total = 0
    for _, genInfo in ipairs(generatorsData:GetChildren()) do
        local count = ownedGenerators[genInfo.Name] or 0
        total = total + (count * genInfo.CoinsPerSec.Value)
    end
    coinsPerSecLabel.Text = "💰 " .. total .. " coins/sec"
end

-- ===== CRÉER UNE LIGNE DE GÉNÉRATEUR =====
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
    
    -- Nom du générateur
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
    
    -- Production/sec de ce générateur
    local prodLabel = Instance.new("TextLabel")
    prodLabel.Size = UDim2.new(0.55, 0, 0, 20)
    prodLabel.Position = UDim2.new(0, 10, 0, 30)
    prodLabel.Text = "+" .. genInfo.CoinsPerSec.Value .. " coins/sec"
    prodLabel.TextSize = 12
    prodLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    prodLabel.BackgroundTransparency = 1
    prodLabel.Font = Enum.Font.Gotham
    prodLabel.TextXAlignment = Enum.TextXAlignment.Left
    prodLabel.Parent = row
    
    -- Compteur possédé
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
    
    -- Bouton acheter (avec coût dynamique)
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
    
    -- Fonction de mise à jour de cette row
    local function updateRow()
        local owned = ownedGenerators[genInfo.Name] or 0
        local currentCost = math.floor(genInfo.BaseCost.Value * (COST_MULTIPLIER ^ owned))
        buyButton.Text = currentCost .. " 💰"
        ownedLabel.Text = "Possédé : " .. owned
    end
    
    updateRow()
    rowsUpdaters[genInfo.Name] = updateRow
    
    buyButton.MouseButton1Click:Connect(function()
        buyGeneratorEvent:FireServer(genInfo.Name)
    end)
end

-- ===== ÉCOUTER LES CHANGEMENTS D'ACHATS =====
generatorsOwnedEvent.OnClientEvent:Connect(function(owned)
    ownedGenerators = owned
    -- Rafraîchir toutes les rows
    for _, updater in pairs(rowsUpdaters) do
        updater()
    end
    updateTotalCoinsPerSec()
end)

-- ===== CRÉER LES 5 LIGNES DE GÉNÉRATEURS (dans l'ordre) =====
for i, genId in ipairs(GENERATOR_IDS) do
    local genInfo = generatorsData:FindFirstChild(genId)
    if genInfo then
        createGeneratorRow(genInfo, i)
    end
end

updateTotalCoinsPerSec()
