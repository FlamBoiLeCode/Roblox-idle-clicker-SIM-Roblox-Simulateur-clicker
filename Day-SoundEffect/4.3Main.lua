-- Main.lua V4.3 TikTok (ServerScriptService)
-- Features : MVP + F1 (Upgrades) + F2 (Générateurs) + F3 (Prestige) + F4.2 (ClickResultEvent)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local dataStore = DataStoreService:GetDataStore("PlayerData_v3")

-- ===== CONSTANTES =====
local COST_MULTIPLIER = 1.15
local PRESTIGE_THRESHOLD = 100000
local PRESTIGE_BONUS = 0.1

-- ===== UPGRADES (Feature 1) =====
local UPGRADES = {
	{id = "upgrade1", name = "Basique", cost = 10, bonus = 1},
	{id = "upgrade2", name = "Avancée", cost = 100, bonus = 5},
	{id = "upgrade3", name = "Pro", cost = 1000, bonus = 25},
	{id = "upgrade4", name = "Elite", cost = 10000, bonus = 100},
	{id = "upgrade5", name = "Légendaire", cost = 100000, bonus = 500},
}

-- ===== GÉNÉRATEURS (Feature 2) =====
local GENERATORS = {
	{id = "gen1", name = "🌾 Ferme", baseCost = 50, coinsPerSec = 1},
	{id = "gen2", name = "⛏️ Mine", baseCost = 500, coinsPerSec = 10},
	{id = "gen3", name = "🏭 Usine", baseCost = 5000, coinsPerSec = 100},
	{id = "gen4", name = "🤖 Robot", baseCost = 50000, coinsPerSec = 1000},
	{id = "gen5", name = "🧠 IA", baseCost = 500000, coinsPerSec = 10000},
}

-- ===== SETUP UPGRADES DATA (ReplicatedStorage) =====
local upgradesFolder = Instance.new("Folder")
upgradesFolder.Name = "UpgradesData"
upgradesFolder.Parent = ReplicatedStorage

for _, upgrade in ipairs(UPGRADES) do
	local upgradeInfo = Instance.new("Folder")
	upgradeInfo.Name = upgrade.id
	upgradeInfo.Parent = upgradesFolder

	local displayName = Instance.new("StringValue")
	displayName.Name = "DisplayName"
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

-- ===== SETUP GENERATORS DATA (ReplicatedStorage) =====
local generatorsFolder = Instance.new("Folder")
generatorsFolder.Name = "GeneratorsData"
generatorsFolder.Parent = ReplicatedStorage

for _, gen in ipairs(GENERATORS) do
	local genInfo = Instance.new("Folder")
	genInfo.Name = gen.id
	genInfo.Parent = generatorsFolder

	local displayName = Instance.new("StringValue")
	displayName.Name = "DisplayName"
	displayName.Value = gen.name
	displayName.Parent = genInfo

	local baseCost = Instance.new("IntValue")
	baseCost.Name = "BaseCost"
	baseCost.Value = gen.baseCost
	baseCost.Parent = genInfo

	local coinsPerSec = Instance.new("IntValue")
	coinsPerSec.Name = "CoinsPerSec"
	coinsPerSec.Value = gen.coinsPerSec
	coinsPerSec.Parent = genInfo
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

-- F4.2 : envoie le gain au client pour animation flottante
local clickResultEvent = Instance.new("RemoteEvent")
clickResultEvent.Name = "ClickResultEvent"
clickResultEvent.Parent = ReplicatedStorage

-- ===== DONNÉES JOUEURS =====
local playerData = {}

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

Players.PlayerAdded:Connect(function(player)
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

	local data = {
		coins = coins,
		prestigePointsValue = prestige,
		clickPower = 1,
		upgrades = {},
		generators = {},
		prestigePoints = 0
	}

	local success, saved = pcall(function()
		return dataStore:GetAsync(player.UserId)
	end)

	if success and saved then
		coins.Value = saved.coins or 0
		data.upgrades = saved.upgrades or {}
		data.generators = saved.generators or {}
		data.prestigePoints = saved.prestigePoints or 0
		prestige.Value = data.prestigePoints
		recalculateClickPower(data)
	end

	playerData[player.UserId] = data

	task.wait(1)
	upgradesOwnedEvent:FireClient(player, data.upgrades)
	generatorsOwnedEvent:FireClient(player, data.generators)
	prestigeInfoEvent:FireClient(player, data.prestigePoints, 1 + (data.prestigePoints * PRESTIGE_BONUS))
end)

Players.PlayerRemoving:Connect(function(player)
	local data = playerData[player.UserId]
	if data then
		pcall(function()
			dataStore:SetAsync(player.UserId, {
				coins = data.coins.Value,
				upgrades = data.upgrades,
				generators = data.generators,
				prestigePoints = data.prestigePoints
			})
		end)
	end
	playerData[player.UserId] = nil
end)

-- ===== CLIC (avec F4.2 envoi gain au client) =====
clickEvent.OnServerEvent:Connect(function(player)
	local data = playerData[player.UserId]
	if data then
		local multiplier = 1 + (data.prestigePoints * PRESTIGE_BONUS)
		local gain = math.floor(data.clickPower * multiplier)
		data.coins.Value = data.coins.Value + gain
		clickResultEvent:FireClient(player, gain) -- F4.2
	end
end)

-- ===== ACHAT UPGRADE (Feature 1) =====
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
	data.clickPower = data.clickPower + upgrade.bonus

	upgradesOwnedEvent:FireClient(player, data.upgrades)
end)

-- ===== ACHAT GÉNÉRATEUR (Feature 2) =====
buyGeneratorEvent.OnServerEvent:Connect(function(player, generatorId)
	local data = playerData[player.UserId]
	if not data then return end

	local gen
	for _, g in ipairs(GENERATORS) do
		if g.id == generatorId then
			gen = g
			break
		end
	end
	if not gen then return end

	local currentOwned = data.generators[generatorId] or 0
	local actualCost = getGeneratorCost(gen.baseCost, currentOwned)

	if data.coins.Value < actualCost then return end

	data.coins.Value = data.coins.Value - actualCost
	data.generators[generatorId] = currentOwned + 1

	generatorsOwnedEvent:FireClient(player, data.generators)
end)

-- ===== PRESTIGE (Feature 3) =====
prestigeEvent.OnServerEvent:Connect(function(player)
	local data = playerData[player.UserId]
	if not data then return end

	local pointsToGain = math.floor(data.coins.Value / PRESTIGE_THRESHOLD)
	if pointsToGain < 1 then return end

	-- Reset TOTAL sauf prestige points
	data.coins.Value = 0
	data.upgrades = {}
	data.generators = {}
	data.clickPower = 1
	data.prestigePoints = data.prestigePoints + pointsToGain
	data.prestigePointsValue.Value = data.prestigePoints

	upgradesOwnedEvent:FireClient(player, data.upgrades)
	generatorsOwnedEvent:FireClient(player, data.generators)
	prestigeInfoEvent:FireClient(player, data.prestigePoints, 1 + (data.prestigePoints * PRESTIGE_BONUS))
end)

-- ===== BOUCLE IDLE INCOME (Feature 2 avec multiplier prestige) =====
task.spawn(function()
	while true do
		task.wait(1)
		for _, data in pairs(playerData) do
			local totalPerSec = 0
			for _, gen in ipairs(GENERATORS) do
				local count = data.generators[gen.id] or 0
				totalPerSec = totalPerSec + (count * gen.coinsPerSec)
			end
			if totalPerSec > 0 then
				local multiplier = 1 + (data.prestigePoints * PRESTIGE_BONUS)
				local gain = math.floor(totalPerSec * multiplier)
				data.coins.Value = data.coins.Value + gain
			end
		end
	end
end)
