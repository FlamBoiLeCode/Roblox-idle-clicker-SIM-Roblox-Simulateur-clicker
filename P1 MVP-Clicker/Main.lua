-- Main.lua (ServerScriptService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local dataStore = DataStoreService:GetDataStore("PlayerData_v1")

-- Créer le RemoteEvent qui recevra les clics
local clickEvent = Instance.new("RemoteEvent")
clickEvent.Name = "ClickEvent"
clickEvent.Parent = ReplicatedStorage

-- Table pour stocker les données de chaque joueur en session
local playerData = {}

-- Fonction chargée quand un joueur rejoint
Players.PlayerAdded:Connect(function(player)
    -- Créer leaderstats (affichera Coins en haut à droite)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    -- Charger la sauvegarde depuis DataStore
    local success, data = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        coins.Value = data.coins or 0
    end
    
    playerData[player.UserId] = {
        coins = coins,
        clickPower = 1  -- Nombre de coins gagnés par clic (upgradable plus tard)
    }
end)

-- Sauvegarder quand un joueur quitte
Players.PlayerRemoving:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        pcall(function()
            dataStore:SetAsync(player.UserId, {
                coins = data.coins.Value,
                clickPower = data.clickPower
            })
        end)
    end
    playerData[player.UserId] = nil
end)

-- Recevoir les clics du client
clickEvent.OnServerEvent:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        data.coins.Value = data.coins.Value + data.clickPower
    end
end)
