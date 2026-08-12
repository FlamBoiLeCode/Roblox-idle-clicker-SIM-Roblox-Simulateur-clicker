# 🎮 Roblox Idle Clicker — Devlog

**🇬🇧 [English](#-english) | 🇫🇷 [Français](#-français)**

---

## 🇬🇧 English

Building a Roblox idle clicker game from scratch — full code, step by step, published progressively on TikTok.

**Watch the devlog series on TikTok:** [@kevinpasflamboyant008](https://www.tiktok.com/@kevinpasflamboyant008)

### 📖 What is this?

A complete, working idle/clicker game in Roblox — coded from zero, with the full code available for free. Each folder in this repo matches a TikTok video (Part 1, Part 2, etc.), so you can follow along and reproduce the exact same game step by step.

Perfect if you're:
- 🎮 Learning Roblox development
- 💻 Learning Lua for the first time
- 🎯 Wanting a working reference for idle game mechanics
- 🚀 Building your own Roblox game

### 🗂️ Repository Structure

Each folder = one TikTok video = one game feature.

| Folder | Feature | TikTok Part |
|--------|---------|-------------|
| `P1 MVP-Clicker/` | Click button + coins + auto-save | Part 1 |
| *(more coming as videos drop)* | Upgrades, generators, prestige, animations, sounds... | Parts 2-8+ |

### 🚀 How to use the code

**Step 1 — Setup Roblox Studio**
1. Open **Roblox Studio**
2. **File** → **New** → **Baseplate**
3. **Home** → **Game Settings** → **Security** → check **"Enable Studio Access to API Services"** ✅ (required for save system)

**Step 2 — Copy the scripts**
- **`Main.lua`** → paste inside **ServerScriptService** (as a `Script`)
- **`ClickHandler.lua`** → paste inside **StarterPlayer** → **StarterPlayerScripts** (as a `LocalScript`)

**Step 3 — Test**
Hit **▶️ Play** in Studio → click the button → watch your coins go up!

### 🛠️ Tech Stack

- **Roblox Studio** + **Lua**
- `DataStoreService` (auto-save)
- `RemoteEvents` (client ↔ server communication)
- `leaderstats` (top-right coin display)

### 📅 Roadmap

- [x] **Part 1** — MVP: click button + auto-save
- [ ] **Part 2** — Upgrade shop (5 upgrades to boost click power)
- [ ] **Part 3** — Passive generators (idle income)
- [ ] **Part 4** — Prestige system (reset for permanent multiplier)
- [ ] **Part 5** — Number formatting (1K, 1M, 1B, T...)
- [ ] **Part 6** — Click animation + floating coins
- [ ] **Part 7** — Sounds (click, purchase, prestige)
- [ ] **Part 8+** — UI polish, particles, milestones, player titles...

### 💬 Questions / Feedback?

- Drop a comment on the TikTok video
- Open an [Issue](../../issues) on this repo
- DM me on TikTok

### ⚠️ Disclaimer

This code is provided **as-is** for learning purposes. Free to use in your own projects (commercial or not). If you make something cool with it, tag me — I'd love to see!

---

## 🇫🇷 Français

Je code un jeu Roblox idle clicker à partir de zéro — code complet, étape par étape, publié au fur et à mesure sur TikTok.

**Regarde la série devlog sur TikTok :** [@kevinpasflamboyant008](https://www.tiktok.com/@kevinpasflamboyant008)

### 📖 C'est quoi ce projet ?

Un jeu idle/clicker Roblox complet et fonctionnel — codé de zéro, avec le code entier dispo gratuitement. Chaque dossier de ce repo correspond à une vidéo TikTok (Partie 1, Partie 2, etc.), donc tu peux suivre pas à pas et reproduire le même jeu exactement.

Parfait si tu veux :
- 🎮 Apprendre le dev Roblox
- 💻 Apprendre Lua pour la première fois
- 🎯 Avoir une référence qui marche pour les mécaniques idle
- 🚀 Construire ton propre jeu Roblox

### 🗂️ Structure du repo

Chaque dossier = une vidéo TikTok = une fonctionnalité du jeu.

| Dossier | Fonctionnalité | Partie TikTok |
|---------|----------------|----------------|
| `P1 MVP-Clicker/` | Bouton clic + coins + sauvegarde auto | Partie 1 |
| *(plus à venir avec chaque vidéo)* | Upgrades, générateurs, prestige, animations, sons... | Parties 2-8+ |

### 🚀 Comment utiliser le code

**Étape 1 — Setup Roblox Studio**
1. Ouvre **Roblox Studio**
2. **Fichier** → **Nouveau** → **Baseplate**
3. **Accueil** → **Paramètres du jeu** → **Sécurité** → coche **"Activer l'accès Studio aux services API"** ✅ (obligatoire pour la sauvegarde)

**Étape 2 — Copie les scripts**
- **`Main.lua`** → colle dans **ServerScriptService** (en tant que `Script`)
- **`ClickHandler.lua`** → colle dans **StarterPlayer** → **StarterPlayerScripts** (en tant que `LocalScript`)

**Étape 3 — Teste**
Appuie sur **▶️ Play** dans Studio → clique le bouton → regarde tes coins monter !

### 🛠️ Stack technique

- **Roblox Studio** + **Lua**
- `DataStoreService` (sauvegarde auto)
- `RemoteEvents` (communication client ↔ serveur)
- `leaderstats` (affichage coins en haut à droite)

### 📅 Roadmap

- [x] **Partie 1** — MVP : bouton clic + sauvegarde auto
- [ ] **Partie 2** — Boutique upgrades (5 upgrades pour booster le clic power)
- [ ] **Partie 3** — Générateurs passifs (idle income)
- [ ] **Partie 4** — Système prestige (reset pour multiplicateur permanent)
- [ ] **Partie 5** — Formatage nombres (1K, 1M, 1B, T...)
- [ ] **Partie 6** — Animation clic + coins flottants
- [ ] **Partie 7** — Sons (clic, achat, prestige)
- [ ] **Partie 8+** — Polish UI, particules, milestones, titres joueur...

### 💬 Questions / Feedback ?

- Laisse un commentaire sur la vidéo TikTok
- Ouvre une [Issue](../../issues) sur ce repo
- DM moi sur TikTok

### ⚠️ Disclaimer

Le code est fourni **tel quel** dans un but éducatif. Libre d'utilisation dans tes propres projets (commercial ou non). Si tu crées un truc cool avec, tag-moi — j'adore voir ce que les gens font !

---

**Made with ❤️ by [FlamBoiLeCode](https://github.com/FlamBoiLeCode)**
