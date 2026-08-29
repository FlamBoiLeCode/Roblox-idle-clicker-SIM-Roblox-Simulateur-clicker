-- GeneratorsUI.lua (StarterPlayerScripts) — DAY 6 : Générateurs + NumberFormatter
-- (Inchangé depuis DAY 5)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NumberFormatter = require(ReplicatedStorage:WaitForChild("NumberFormatter"))

local player = Players.LocalPlayer
local buyGeneratorEvent = ReplicatedStorage:WaitForChild("BuyGeneratorEvent")
local generatorsOwnedEvent = ReplicatedStorage:WaitForChild("GeneratorsOwnedEvent")
local generatorsData = ReplicatedStorage:WaitForChild("GeneratorsData")

local playerGui = player:WaitForChild("PlayerGui")

-- Attendre que TOUS les generators soient créés côté serveur (fix timing)
local GENERATOR_IDS = {"gen1", "gen2", "gen3", "gen4", "gen5"}
for _, genId in ipairs(GENERATOR_IDS) do
    generatorsData:WaitForChild(genId, 10)
end

task.wait(0.2)

local COST_MULTIPLIER = 1.15
local ownedGenerators = {}
local rowsUpdaters = {}

-- ===== ScreenGui séparé =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeneratorsUI"
screenGui.Parent = playerGui

-- ===== BOUTON OUVRIR GÉNÉRATEURS =====
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

-- ===== PANNEAU GÉNÉRATEURS =====
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

local genTitle = Instance.new("TextLabel")
genTitle.Size = UDim2.new(1, 0, 0, 40)
genTitle.Text = "🏭 GÉNÉRATEURS"
genTitle.TextSize = 22
genTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
genTitle.BackgroundTransparency = 1
genTitle.Font = Enum.Font.GothamBold
genTitle.Parent = genFrame

local totalLabel = Instance.new("TextLabel")
totalLabel.Size = UDim2.new(1, -20, 0, 30)
totalLabel.Position = UDim2.new(0, 10, 0, 45)
totalLabel.Text = "Total : 0 coins/sec"
totalLabel.TextSize = 14
totalLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
totalLabel.BackgroundTransparency = 1
totalLabel.Font = Enum.Font.Gotham
totalLabel.Parent = genFrame

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
        total = total + (count * genInfo.BaseRate.Value)
    end
    totalLabel.Text = "Total : " .. NumberFormatter.format(total) .. " coins/sec"
end

-- ===== CRÉER UNE LIGNE DE GÉNÉRATEUR =====
local function createGeneratorRow(genInfo, index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 70)
    row.Position = UDim2.new(0, 10, 0, 90 + (index - 1) * 75)
    row.BackgroundColor3 = Color3.fromRGB(60, 70, 110)
    row.BorderSizePixel = 0
    row.Parent = genFrame
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.Text = genInfo.DisplayName.Value
    nameLabel.TextSize = 15
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row
    
    local ownedLabel = Instance.new("TextLabel")
    ownedLabel.Size = UDim2.new(0.5, 0, 0.4, 0)
    ownedLabel.Position = UDim2.new(0, 10, 0.5, 0)
    ownedLabel.Text = "Possédé : 0 (+" .. NumberFormatter.format(genInfo.BaseRate.Value) .. "/sec chacun)"
    ownedLabel.TextSize = 12
    ownedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ownedLabel.BackgroundTransparency = 1
    ownedLabel.Font = Enum.Font.Gotham
    ownedLabel.TextXAlignment = Enum.TextXAlignment.Left
    ownedLabel.Parent = row
    
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(0.35, 0, 0.7, 0)
    buyButton.Position = UDim2.new(0.62, 0, 0.15, 0)
    buyButton.Text = NumberFormatter.format(genInfo.BaseCost.Value) .. " 💰"
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
    end)
end

-- ===== ÉCOUTER LES CHANGEMENTS D'ACHAT =====
generatorsOwnedEvent.OnClientEvent:Connect(function(owned)
    ownedGenerators = owned
    for _, updater in pairs(rowsUpdaters) do
        updater()
    end
    updateTotalCoinsPerSec()
end)

for index, genId in ipairs(GENERATOR_IDS) do
    local genInfo = generatorsData:WaitForChild(genId)
    createGeneratorRow(genInfo, index)
end

updateTotalCoinsPerSec()
