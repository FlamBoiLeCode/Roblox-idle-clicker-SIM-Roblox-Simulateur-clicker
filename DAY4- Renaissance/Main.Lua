-- Main.lua (ServerScriptService) — DAY 4 : Prestige System
-- Contient : MVP + Upgrades + Générateurs + Prestige

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local dataStore = DataStoreService:GetDataStore("PlayerData_v1")

-- ===== CONSTANTES =====
local COST_MULTIPLIER = 1.15
local PRESTIGE_THRESHOLD = 100000
local PRESTIGE_BONUS = 0.1

-- ===== TABLE UPGRADES =====
local UPGRADES = {
    {id = "upgrade1", displayName = "Basique",   cost = 10,     bonus = 1},
    {id = "upgrade2", displayName = "Rare",      cost = 100,    bonus = 2},
    {id = "upgrade3", displayName = "Épique",    cost = 1000,   bonus = 5},
    {id = "upgrade4", displayName = "Mythique",  cost = 10000,  bonus = 10},
    {id = "upgrade5", displayName = "Legendary", cost = 100000, bonus = 25},
}

-- ===== TABLE GENERATORS =====
local GENERATORS = {
    {id = "gen1", displayName = "Machine à sous", baseCost = 50,     baseRate = 1},
    {id = "gen2", displayName = "Distributeur",   baseCost = 500,    baseRate = 5},
    {id = "gen3", displayName = "Usine",          baseCost = 5000,   baseRate = 25},
    {id = "gen4", displayName = "Complexe",       baseCost = 50000,  baseRate = 100},
    {id = "gen5", displayName = "Empire",         baseCost = 500000, baseRate = 500},
}

-- ===== SETUP FOLDERS DATA DANS REPLICATED STORAGE =====
-- UpgradesData : les infos publiques des upgrades pour le client
local upgradesData = Instance.new("Folder")
upgradesData.Name = "UpgradesData"
upgradesData.Parent = ReplicatedStorage

for _, u in ipairs(UPGRADES) do
    local upFolder = Instance.new("Folder")
    upFolder.Name = u.id
    upFolder.Parent = upgradesData
    
    local nameVal = Instance.new("StringValue")
    nameVal.Name = "DisplayName"
    nameVal.Value = u.displayName
    nameVal.Parent = upFolder
    
    local costVal = Instance.new("IntValue")
    costVal.Name = "Cost"
    costVal.Value = u.cost
    costVal.Parent = upFolder
    
    local bonusVal = Instance.new("IntValue")
    bonusVal.Name = "Bonus"
    bonusVal.Value = u.bonus
    bonusVal.Parent = upFolder
end

-- GeneratorsData : les infos publiques des générateurs pour le client
local generatorsData = Instance.new("Folder")
generatorsData.Name = "GeneratorsData"
generatorsData.Parent = ReplicatedStorage

for _, g in ipairs(GENERATORS) do
    local genFolder = Instance.new("Folder")
    genFolder.Name = g.id
    genFolder.Parent = generatorsData
    
    local nameVal = Instance.new("StringValue")
    nameVal.Name = "DisplayName"
    nameVal.Value = g.displayName
    nameVal.Parent = genFolder
    
    local costVal = Instance.new("IntValue")
    costVal.Name = "BaseCost"
    costVal.Value = g.baseCost
    costVal.Parent = genFolder
    
    local rateVal = Instance.new("IntValue")
    rateVal.Name = "BaseRate"
    rateVal.Value = g.baseRate
    rateVal.Parent = genFolder
end

-- ===== REMOTE EVENTS =====
local clickEvent = Instance.new("RemoteEvent")
clickEvent.Name = "ClickEvent"
clickEvent.Parent = ReplicatedStorage

local upgradeEvent = Instance.new("RemoteEvent")
upgradeEvent.Name = "UpgradeEvent"
upgradeEvent.Parent = ReplicatedStorage

local upgradesOwnedEvent = Instance.new("RemoteEvent")
upgradesOwnedEvent.Name = "UpgradesOwnedEvent"
upgradesOwnedEvent.Parent = ReplicatedStorage

local buyGeneratorEvent = Instance.new("RemoteEvent")
buyGeneratorEvent.Name = "BuyGeneratorEvent"
buyGeneratorEvent.Parent = ReplicatedStorage

local generatorsOwnedEvent = Instance.new("RemoteEvent")
generatorsOwnedEvent.Name = "GeneratorsOwnedEvent"
generatorsOwnedEvent.Parent = ReplicatedStorage

local prestigeEvent = Instance.new("RemoteEvent")
prestigeEvent.Name = "PrestigeEvent"
prestigeEvent.Parent = ReplicatedStorage

local prestigeInfoEvent = Instance.new("RemoteEvent")
prestigeInfoEvent.Name = "PrestigeInfoEvent"
prestigeInfoEvent.Parent = ReplicatedStorage

-- ===== DONNÉES JOUEURS =====
local playerData = {}

-- ===== FONCTIONS UTILITAIRES =====
local function getGeneratorCost(baseCost, currentOwned)
    return math.floor(baseCost * (COST_MULTIPLIER ^ currentOwned))
end

local function recalculateClickPower(data)
    local power = 1
    for _, u in ipairs(UPGRADES) do
        if data.upgrades[u.id] then
            power = power + u.bonus
        end
    end
    data.clickPower = power
end

-- ===== JOUEUR REJOINT =====
Players.PlayerAdded:Connect(function(player)
    -- Leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    local prestige = Instance.new("IntValue")
    prestige.Name = "Prestige ⭐"
    prestige.Value = 0
    prestige.Parent = leaderstats
    
    -- Data structure init
    local data = {
        coins = coins,
        prestigePointsValue = prestige,
        clickPower = 1,
        upgrades = {},
        generators = {},
        prestigePoints = 0,
    }
    
    -- Chargement DataStore
    local success, loaded = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success and loaded then
        coins.Value = loaded.coins or 0
        data.upgrades = loaded.upgrades or {}
        data.generators = loaded.generators or {}
        data.prestigePoints = loaded.prestigePoints or 0
        prestige.Value = data.prestigePoints
        recalculateClickPower(data)
    end
    
    playerData[player.UserId] = data
    
    -- Envoyer les upgrades/générateurs déjà possédés au client
    task.wait(0.5)
    upgradesOwnedEvent:FireClient(player, data.upgrades)
    generatorsOwnedEvent:FireClient(player, data.generators)
    prestigeInfoEvent:FireClient(player, data.prestigePoints, 1 + (data.prestigePoints * PRESTIGE_BONUS))
end)

-- ===== JOUEUR QUITTE : SAUVEGARDE =====
Players.PlayerRemoving:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        pcall(function()
            dataStore:SetAsync(player.UserId, {
                coins = data.coins.Value,
                upgrades = data.upgrades,
                generators = data.generators,
                prestigePoints = data.prestigePoints,
            })
        end)
    end
    playerData[player.UserId] = nil
end)

-- ===== CLIC =====
clickEvent.OnServerEvent:Connect(function(player)
    local data = playerData[player.UserId]
    if data then
        local multiplier = 1 + (data.prestigePoints * PRESTIGE_BONUS)
        local gain = math.floor(data.clickPower * multiplier)
        data.coins.Value = data.coins.Value + gain
    end
end)

-- ===== ACHAT UPGRADE =====
upgradeEvent.OnServerEvent:Connect(function(player, upgradeId)
    local data = playerData[player.UserId]
    if not data then return end
    
    local upgrade
    for _, u in ipairs(UPGRADES) do
        if u.id == upgradeId then
            upgrade = u
            break
        end
    end
    if not upgrade then return end
    
    if data.upgrades[upgradeId] then return end
    if data.coins.Value < upgrade.cost then return end
    
    data.coins.Value = data.coins.Value - upgrade.cost
    data.upgrades[upgradeId] = true
    recalculateClickPower(data)
    
    upgradesOwnedEvent:FireClient(player, data.upgrades)
end)

-- ===== ACHAT GÉNÉRATEUR =====
buyGeneratorEvent.OnServerEvent:Connect(function(player, genId)
    local data = playerData[player.UserId]
    if not data then return end
    
    local generator
    for _, g in ipairs(GENERATORS) do
        if g.id == genId then
            generator = g
            break
        end
    end
    if not generator then return end
    
    local currentOwned = data.generators[genId] or 0
    local cost = getGeneratorCost(generator.baseCost, currentOwned)
    
    if data.coins.Value < cost then return end
    
    data.coins.Value = data.coins.Value - cost
    data.generators[genId] = currentOwned + 1
    
    generatorsOwnedEvent:FireClient(player, data.generators)
end)

-- ===== REVENU PASSIF GÉNÉRATEURS (chaque seconde) =====
task.spawn(function()
    while true do
        task.wait(1)
        for userId, data in pairs(playerData) do
            local totalPerSec = 0
            for _, gen in ipairs(GENERATORS) do
                local count = data.generators[gen.id] or 0
                totalPerSec = totalPerSec + (count * gen.baseRate)
            end
            local multiplier = 1 + (data.prestigePoints * PRESTIGE_BONUS)
            data.coins.Value = data.coins.Value + math.floor(totalPerSec * multiplier)
        end
    end
end)

-- ===== PRESTIGE =====
prestigeEvent.OnServerEvent:Connect(function(player)
    local data = playerData[player.UserId]
    if not data then return end
    
    local pointsToGain = math.floor(data.coins.Value / PRESTIGE_THRESHOLD)
    if pointsToGain <= 0 then return end
    
    -- Reset coins, upgrades, générateurs
    data.coins.Value = 0
    data.upgrades = {}
    data.generators = {}
    
    -- Ajouter les points de prestige
    data.prestigePoints = data.prestigePoints + pointsToGain
    data.prestigePointsValue.Value = data.prestigePoints
    
    -- Recalculer le clic power (retour à 1 puisque les upgrades sont reset)
    recalculateClickPower(data)
    
    -- Envoyer les nouvelles données au client
    upgradesOwnedEvent:FireClient(player, data.upgrades)
    generatorsOwnedEvent:FireClient(player, data.generators)
    prestigeInfoEvent:FireClient(player, data.prestigePoints, 1 + (data.prestigePoints * PRESTIGE_BONUS))
end)

-- ===== AUTOSAVE toutes les 60 secondes =====
task.spawn(function()
    while true do
        task.wait(60)
        for userId, data in pairs(playerData) do
            local player = Players:GetPlayerByUserId(userId)
            if player then
                pcall(function()
                    dataStore:SetAsync(userId, {
                        coins = data.coins.Value,
                        upgrades = data.upgrades,
                        generators = data.generators,
                        prestigePoints = data.prestigePoints,
                    })
                end)
            end
        end
    end
end)
