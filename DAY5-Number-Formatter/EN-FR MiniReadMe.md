# 🔢 Day 5 — Number Formatter

**🇬🇧 [English](#-english) | 🇫🇷 [Français](#-français)**

---

## 🇬🇧 English

### What this feature adds

A **NumberFormatter ModuleScript** that converts big raw numbers into readable suffixed versions:
- `1000` → `1K`
- `1500` → `1.5K`
- `1000000` → `1M`
- `5847623` → `5.8M`
- `1000000000` → `1B`
- Up to Sextillion (`S`) for late-game numbers

Once created, it's integrated across the UI scripts (ClickHandler, GeneratorsUI, PrestigeUI) so that ALL displayed numbers get formatted instead of showing raw values like `847329450`.

### Why it matters

- **Readability = playability** — nobody wants to read `5847623 coins`, everyone reads `5.8M coins` instantly
- **Essential for idle games** — numbers grow FAST (exponential progression), unreadable big numbers = players quit
- **Reusable across the whole project** — one ModuleScript, called from anywhere with `NumberFormatter.format(number)`
- **Standard practice** in AdVenture Capitalist, Cookie Clicker, Egg Inc, and every idle game that succeeded

### Prerequisites

- ✅ **P1 MVP-Clicker** installed
- ✅ **DAY2-Upgrade-Shop** installed
- ✅ **DAY3-Generators** installed
- ✅ **DAY4-Prestige-System** installed (this feature polishes the visuals of all previous features)

### Files in this folder

- **`NumberFormatter.lua`** → paste inside `ReplicatedStorage` (as a **ModuleScript**, NOT a Script!) — the core formatting logic
- **`ClickHandler.lua`** → replaces DAY2 version — same UI code + NumberFormatter integrated at 2 spots
- **`GeneratorsUI.lua`** → replaces DAY3 version — same UI code + NumberFormatter integrated at 4 spots
- **`PrestigeUI.lua`** → replaces DAY4 version — same UI code + NumberFormatter integrated at 1 spot

> ⚠️ **Note about `Main.lua`:** it's not included in this folder because it hasn't changed since DAY4. If you're coming from DAY4, keep your existing `Main.lua`. If you're jumping straight to DAY5, grab it from the `DAY4-Prestige-System/` folder.

### Where NumberFormatter is used (integration spots)

**ClickHandler.lua** (2 spots — Upgrade shop button text):
- Initial cost display
- `updateAppearance()` cost display (⚠️ easy to forget!)

**GeneratorsUI.lua** (4 spots — Generator panel):
- Header total coins/sec
- Initial coins/sec per generator (info label)
- Initial buy button cost
- **`updateRow()` dynamic cost** (THE most important — costs grow x1.15 per purchase, quickly become huge)

**PrestigeUI.lua** (1 spot):
- `updateInfo()` minimum threshold display (`⛔ Pas assez de coins (min : 100K)`)

### Test it

1. Save all scripts (including NumberFormatter as ModuleScript)
2. Hit **▶️ Play** in Studio
3. Click a few times to gain coins
4. Open Boutique (🛒) → prices should show `10`, `100`, `1K`, `10K`, `100K` (not raw numbers)
5. Open Générateurs (🏭) → costs and coins/sec show `50`, `500`, `5K`, `50K` etc.
6. Open Prestige (★) → without enough coins, message shows `min : 100K` (not `min : 100000`)

### 🎥 Watch the video

**TikTok Part 5:** [https://vm.tiktok.com/ZN8Nkb16a/](https://www.tiktok.com/@kevinpasflamboyant008)

### Known notes

- The `leaderstats` top-right coins counter can NOT be formatted (it's an IntValue native to Roblox, always shows raw numbers). Only custom UI panels can use NumberFormatter.
- Formatting adds 1 decimal for small values (`1.5K`), removes it when clean (`10K` not `10.0K`), and uses integer only for values ≥ 100 within a suffix range (`120K` not `120.0K`).
- If you add more features later (notifications, floating coins, etc.), reuse `NumberFormatter.format()` for consistency.

---

## 🇫🇷 Français

### Ce que cette feature ajoute

Un **ModuleScript NumberFormatter** qui convertit les grands nombres bruts en versions abrégées lisibles :
- `1000` → `1K`
- `1500` → `1.5K`
- `1000000` → `1M`
- `5847623` → `5.8M`
- `1000000000` → `1B`
- Jusqu'à Sextillion (`S`) pour la fin de jeu

Une fois créé, il est intégré dans les scripts UI (ClickHandler, GeneratorsUI, PrestigeUI) pour que TOUS les nombres affichés soient formatés au lieu de montrer des valeurs brutes comme `847329450`.

### Pourquoi c'est important

- **Lisibilité = jouabilité** — personne ne veut lire `5847623 coins`, tout le monde lit `5.8M coins` instantanément
- **Essentiel pour les idle games** — les nombres grossissent VITE (progression exponentielle), nombres illisibles = joueurs qui quittent
- **Réutilisable dans tout le projet** — un ModuleScript, appelé depuis n'importe où avec `NumberFormatter.format(number)`
- **Pratique standard** dans AdVenture Capitalist, Cookie Clicker, Egg Inc, et tous les idle games qui ont réussi

### Prérequis

- ✅ **P1 MVP-Clicker** installé
- ✅ **DAY2-Upgrade-Shop** installé
- ✅ **DAY3-Generators** installé
- ✅ **DAY4-Prestige-System** installé (cette feature polit les visuels de toutes les features précédentes)

### Fichiers dans ce dossier

- **`NumberFormatter.lua`** → colle dans `ReplicatedStorage` (en tant que **ModuleScript**, PAS un Script !) — la logique centrale de formatage
- **`ClickHandler.lua`** → remplace la version DAY2 — même code UI + NumberFormatter intégré à 2 endroits
- **`GeneratorsUI.lua`** → remplace la version DAY3 — même code UI + NumberFormatter intégré à 4 endroits
- **`PrestigeUI.lua`** → remplace la version DAY4 — même code UI + NumberFormatter intégré à 1 endroit

> ⚠️ **Note sur `Main.lua` :** il n'est pas inclus dans ce dossier car il n'a pas changé depuis DAY4. Si tu viens de DAY4, garde ton `Main.lua` existant. Si tu sautes directement à DAY5, récupère-le depuis le dossier `DAY4-Prestige-System/`.

### Où NumberFormatter est utilisé (points d'intégration)

**ClickHandler.lua** (2 endroits — texte des boutons Boutique) :
- Affichage du coût initial
- `updateAppearance()` affichage coût (⚠️ facile à oublier !)

**GeneratorsUI.lua** (4 endroits — Panneau Générateurs) :
- Total coins/sec en header
- Coins/sec par générateur initial (label info)
- Coût du bouton d'achat initial
- **`updateRow()` coût dynamique** (LE plus important — les coûts grossissent x1.15 par achat, deviennent énormes très vite)

**PrestigeUI.lua** (1 endroit) :
- `updateInfo()` affichage du seuil minimum (`⛔ Pas assez de coins (min : 100K)`)

### Comment tester

1. Sauvegarde tous les scripts (dont NumberFormatter en tant que ModuleScript)
2. Appuie sur **▶️ Play** dans Studio
3. Clique quelques fois pour gagner des coins
4. Ouvre la Boutique (🛒) → les prix doivent s'afficher `10`, `100`, `1K`, `10K`, `100K` (pas les nombres bruts)
5. Ouvre les Générateurs (🏭) → coûts et coins/sec s'affichent `50`, `500`, `5K`, `50K` etc.
6. Ouvre le Prestige (★) → sans assez de coins, le message affiche `min : 100K` (pas `min : 100000`)

### 🎥 Regarde la vidéo

**TikTok Partie 5 :** [https://vm.tiktok.com/ZN8Nkb16a/](https://www.tiktok.com/@kevinpasflamboyant008)

### Notes

- Le compteur coins dans `leaderstats` (haut-droite) **ne peut PAS être formaté** (c'est un IntValue natif Roblox, il affichera toujours les nombres bruts). Seuls les UI panels custom peuvent utiliser NumberFormatter.
- Le formatage ajoute 1 décimale pour les petites valeurs (`1.5K`), la retire quand c'est propre (`10K` pas `10.0K`), et utilise uniquement les entiers pour les valeurs ≥ 100 dans un intervalle (`120K` pas `120.0K`).
- Si tu ajoutes plus de features plus tard (notifications, coins flottants, etc.), réutilise `NumberFormatter.format()` pour la cohérence.

---

**➡️ Next / Suivant : DAY6 — Click Animation (bounce + floating "+X" coins, coming soon)**
