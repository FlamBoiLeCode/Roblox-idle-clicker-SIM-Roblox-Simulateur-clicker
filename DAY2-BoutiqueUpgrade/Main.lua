-- Main.lua (ServerScriptService) — VERSION AVEC UPGRADES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local dataStore = DataStoreService:GetDataStore("PlayerData_v2")

-- ===== DÉFINITION DES UPGRADES =====
-- Définies côté serveur pour éviter le cheat client
local UPGRADES = {
    {id = "upgrade1", name = "Basique", cost = 10, bonus = 1},
    {id = "upgrade2", name = "Avancée", cost = 100, bonus = 5},
    {id = "upgrade3", name = "Pro", cost = 1000, bonus = 25},
    {id = "upgrade4", name = "Elite", cost = 10000, bonus = 100},
    {id = "upgrade5", name = "Légendaire", cost = 100000, bonus = 500},
}

-- Fournir la liste des upgrades au client (via ReplicatedStorage)
local upgradesFolder = Instance.new("Folder")
upgradesFolder.Name = "UpgradesData"
upgradesFolder.Parent = ReplicatedStorage

for _, upgrade in ipairs(UPGRADES) do
    local upgradeInfo = Instance.new("Folder")
    upgradeInfo.Name = upgrade.id
    upgradeInfo.Parent = upgradesFolder
    
    local displayName = Instance.new("StringValue")
    displayName.Name = "DisplayName"  -- ⚠️ "DisplayName" au lieu de "Name" (évite conflit avec la propriété Name de Roblox)
    displayName.Value = upgrade.name
    displayName.Parent = upgradeInfo
    
    local cost = Instance.new("IntValue")
    cost.Name = "Cost"
    cost.Value = upgrade.cost
    cost.Parent = upgradeInfo
    
    local bonus = Instance.new("IntValue")
    bonus.Name = "Bonus"
    bonus.Value = upgrade.bonus
    bonus.Parent = upgradeInfo
end

-- ===== REMOTE EVENTS =====
local clickEvent = Instance.new("RemoteEvent")
clickEvent.Name = "ClickEvent"
clickEvent.Parent = ReplicatedStorage

local upgradeEvent = Instance.new("RemoteEvent")
upgradeEvent.Name = "UpgradeEvent"
upgradeEvent.Parent = ReplicatedStorage

-- Pour envoyer au client la liste des upgrades qu'il a déjà achetées
local upgradesOwnedEvent = Instance.new("RemoteEvent")
upgradesOwnedEvent.Name = "UpgradesOwnedEvent"
upgradesOwnedEvent.Parent = ReplicatedStorage

-- ===== DONNÉES JOUEURS =====
local playerData = {}

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    -- Structure de données joueur
    local data = {
        coins = coins,
        clickPower = 1,
        upgrades = {}
    }
    
    -- Charger depuis DataStore
    local success, saved = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success and saved then
        coins.Value = saved.coins or 0
        data.clickPower = saved.clickPower or 1
        data.upgrades = saved.upgrades or {}
    end
    
    playerData[player.UserId] = data
    
    -- Envoyer au client la liste de ses upgrades déjà achetées
    task.wait(1) -- attendre que le client soit prêt
    upgradesOwnedEvent:FireClient(player, data.upgrades)
end)

Players.PlayerRemoving:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        pcall(function()
            dataStore:SetAsync(player.UserId, {
                coins = data.coins.Value,
                clickPower = data.clickPower,
                upgrades = data.upgrades
            })
        end)
    end
    playerData[player.UserId] = nil
end)

-- ===== CLIC =====
clickEvent.OnServerEvent:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        data.coins.Value = data.coins.Value + data.clickPower
    end
end)

-- ===== ACHAT UPGRADE =====
upgradeEvent.OnServerEvent:Connect(function(player, upgradeId)
    local data = playerData[player.UserId]
    if not data then return end
    
    -- Trouver l'upgrade
    local upgrade
    for _, u in ipairs(UPGRADES) do
        if u.id == upgradeId then
            upgrade = u
            break
        end
    end
    if not upgrade then return end
    
    -- Déjà acheté ?
    if data.upgrades[upgradeId] then return end
    
    -- Assez de coins ?
    if data.coins.Value < upgrade.cost then return end
    
    -- Acheter
    data.coins.Value = data.coins.Value - upgrade.cost
    data.upgrades[upgradeId] = true
    data.clickPower = data.clickPower + upgrade.bonus
    
    -- Notifier le client que l'achat a réussi
    upgradesOwnedEvent:FireClient(player, data.upgrades)
end)
