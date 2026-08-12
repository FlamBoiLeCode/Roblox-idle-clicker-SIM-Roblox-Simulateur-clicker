-- ClickHandler.lua (StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local clickEvent = ReplicatedStorage:WaitForChild("ClickEvent")

-- Attendre que le PlayerGui existe
local playerGui = player:WaitForChild("PlayerGui")

-- Créer l'interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickerUI"
screenGui.Parent = playerGui

-- Bouton principal "Cliquer pour gagner"
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 100)
button.Position = UDim2.new(0.5, -125, 0.7, 0)
button.Text = "CLIQUER 💰"
button.TextSize = 24
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
button.BorderSizePixel = 0
button.Font = Enum.Font.GothamBold
button.Parent = screenGui

-- Coin arrondi (pour un rendu plus clean)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

-- Effet visuel simple quand on clique
button.MouseButton1Click:Connect(function()
    clickEvent:FireServer()
    -- Petit effet scale (rebond visuel)
    button.Size = UDim2.new(0, 240, 0, 95)
    wait(0.05)
    button.Size = UDim2.new(0, 250, 0, 100)
end)
