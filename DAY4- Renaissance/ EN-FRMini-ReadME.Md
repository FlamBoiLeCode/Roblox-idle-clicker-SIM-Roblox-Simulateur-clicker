# ⭐ Day 4 — Prestige System

**🇬🇧 [English](#-english) | 🇫🇷 [Français](#-français)**

---

## 🇬🇧 English

### What this feature adds

The **Prestige system** — the retention mechanic that turns a simple clicker into a real idle game.

**How it works:**
- Once you reach 100K coins, you can "Prestige"
- Prestige RESETS your coins, upgrades, and generators to zero
- In exchange, you earn Prestige Points (1 per 100K coins reset)
- Each Prestige Point gives a **permanent +10% multiplier** on all coin gains
- You can prestige as many times as you want → each run gets faster than the last

**Formula:** `finalGain = baseGain × (1 + prestigePoints × 0.1)`

Example: at Prestige 10, every click and generator gain is doubled (×2). At Prestige 100, gains are ×11.

### Why it matters

- **THE hook of idle games** — Cookie Clicker, AdVenture Capitalist, all built on prestige loops
- Extends game session by **weeks or months** (each prestige = new run to optimize)
- Creates the "just one more prestige" addictive loop
- Rewards patience AND strategy (when to prestige = key decision)

### Prerequisites

- ✅ **P1 MVP-Clicker** installed
- ✅ **DAY2-Upgrade-Shop** installed
- ✅ **DAY3-Generators** installed (this feature builds on all three)

### Files in this folder

- **`Main.lua`** → paste inside `ServerScriptService` (as a `Script`) — replaces previous Main.lua, now handles prestige logic + multiplier applied server-side
- **`PrestigeUI.lua`** → paste inside `StarterPlayer` → `StarterPlayerScripts` (as a NEW `LocalScript`) — dedicated prestige panel with "PRESTIGE MAINTENANT" button

> ⚠️ **Note about `ClickHandler.lua` and `GeneratorsUI.lua`:** they're not included in this folder because they haven't changed since DAY3. If you're coming from DAY3, keep your existing files. If you're jumping straight to DAY4, grab them from the `DAY3-Generators/` folder.

### Test it

1. Save all scripts
2. Hit **▶️ Play** in Studio
3. Grind up to 100K coins (click + buy upgrades + generators)
4. Click the ⭐ PRESTIGE button → panel opens showing your potential Prestige Points
5. Click **"PRESTIGE MAINTENANT"** → coins reset to 0, prestige point earned, permanent multiplier applied
6. Start over → notice you earn coins **faster** now thanks to the multiplier

### 🎥 Watch the video

**TikTok Part 4:** [https://vm.tiktok.com/ZN8LtMePW/](https://www.tiktok.com/@kevinpasflamboyant008)

### Known notes

- Prestige requires MINIMUM 100K coins (currently fixed — progressive scaling coming in future update)
- Prestige points persist across sessions via DataStore
- Multiplier is applied server-side (secure, no client exploit)
- Warning: prestige is IRREVERSIBLE within a session — no undo

---

## 🇫🇷 Français

### Ce que cette feature ajoute

Le **système Prestige** — la mécanique de rétention qui transforme un simple clicker en vrai idle game.

**Comment ça marche :**
- Une fois que tu atteins 100K coins, tu peux "Prestige"
- Le prestige RESET tes coins, upgrades, et générateurs à zéro
- En échange, tu gagnes des Points de Prestige (1 pour 100K coins reset)
- Chaque Point de Prestige donne un **multiplicateur permanent +10%** sur tous tes gains de coins
- Tu peux prestige autant de fois que tu veux → chaque run devient plus rapide que la précédente

**Formule :** `gainFinal = gainDeBase × (1 + pointsPrestige × 0.1)`

Exemple : à Prestige 10, chaque clic et gain générateur est doublé (×2). À Prestige 100, gains ×11.

### Pourquoi c'est important

- **LE hook des idle games** — Cookie Clicker, AdVenture Capitalist, tous construits sur des boucles de prestige
- Prolonge la durée de session de **semaines ou mois** (chaque prestige = nouvelle run à optimiser)
- Crée la boucle addictive "juste un prestige de plus"
- Récompense la patience ET la stratégie (quand prestige = décision clé)

### Prérequis

- ✅ **P1 MVP-Clicker** installé
- ✅ **DAY2-Upgrade-Shop** installé
- ✅ **DAY3-Generators** installé (cette feature s'appuie sur les trois)

### Fichiers dans ce dossier

- **`Main.lua`** → colle dans `ServerScriptService` (en tant que `Script`) — remplace le Main.lua précédent, gère maintenant la logique prestige + multiplicateur appliqué côté serveur
- **`PrestigeUI.lua`** → colle dans `StarterPlayer` → `StarterPlayerScripts` (en tant que NOUVEAU `LocalScript`) — panneau prestige dédié avec bouton "PRESTIGE MAINTENANT"

> ⚠️ **Note sur `ClickHandler.lua` et `GeneratorsUI.lua` :** ils ne sont pas inclus dans ce dossier car ils n'ont pas changé depuis DAY3. Si tu viens de DAY3, garde tes fichiers existants. Si tu sautes directement à DAY4, récupère-les depuis le dossier `DAY3-Generators/`.

### Comment tester

1. Sauvegarde tous les scripts
2. Appuie sur **▶️ Play** dans Studio
3. Grind jusqu'à 100K coins (clic + achète upgrades + générateurs)
4. Clic sur le bouton ⭐ PRESTIGE → panneau s'ouvre montrant tes Points de Prestige potentiels
5. Clic sur **"PRESTIGE MAINTENANT"** → coins reset à 0, point de prestige gagné, multiplicateur permanent appliqué
6. Recommence → remarque que tu gagnes des coins **plus vite** maintenant grâce au multiplicateur

### 🎥 Regarde la vidéo

**TikTok Partie 4 :** [https://vm.tiktok.com/ZN8LtMePW/](https://www.tiktok.com/@kevinpasflamboyant008)

### Notes

- Le prestige nécessite MINIMUM 100K coins (actuellement fixe — scaling progressif à venir dans une future update)
- Les points de prestige persistent entre sessions via DataStore
- Le multiplicateur est appliqué côté serveur (sécurisé, pas d'exploit client)
- Attention : le prestige est IRRÉVERSIBLE dans une session — pas d'annulation

---

**➡️ Next / Suivant : DAY5 — UI Polish (Number formatting, animations, sounds — coming soon)**
