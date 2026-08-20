# 🏭 Day 3 — Passive Generators (Idle Income)

**🇬🇧 [English](#-english) | 🇫🇷 [Français](#-français)**

---

## 🇬🇧 English

### What this feature adds

A panel with 5 passive generators that produce coins per second **automatically**, even when the player isn't clicking:
- Generator 1: cheap starter (small coins/sec)
- Generator 2, 3, 4, 5: progressively more expensive but more productive

Each generator can be bought multiple times (stackable). Cost increases with each purchase using the standard idle game formula: `baseCost × 1.15^owned`.

Total coins/sec updates in real-time in the panel header.

### Why it matters

- Introduces **idle progression** — the game rewards you even when you're AFK
- Creates a **second loop** on top of clicking: buy generators → earn passively → afford more upgrades → afford more generators
- **Foundation of the idle/incremental genre** — from here on, the game "plays itself"
- Increases session length massively — players come back to see how much they earned overnight

### Prerequisites

- ✅ **P1 MVP-Clicker** installed first
- ✅ **DAY2-Upgrade-Shop** installed (this feature builds on both)

### Files in this folder

- **`Main.lua`** → paste inside `ServerScriptService` (as a `Script`) — replaces previous Main.lua, now handles generators server-side
- **`ClickHandler.lua`** → paste inside `StarterPlayer` → `StarterPlayerScripts` (as a `LocalScript`) — same as DAY2
- **`GeneratorsUI.lua`** → paste inside `StarterPlayer` → `StarterPlayerScripts` (as a NEW `LocalScript`) — dedicated panel for generators

### Test it

1. Save all 3 scripts
2. Hit **▶️ Play** in Studio
3. Click the 🏭 GÉNÉRATEURS button → generator panel opens
4. Buy your first generator → watch your coins tick up automatically every second
5. Buy more → the coins/sec rate increases
6. Leave the game running → come back → coins have piled up

### 🎥 Watch the video

**TikTok Part 3:** [https://vm.tiktok.com/ZN8LQrpYK/](https://www.tiktok.com/@kevinpasflamboyant008)

### Known notes

- Generators stack (buy as many as you want of each)
- Cost formula: `baseCost × 1.15^owned` (standard idle multiplier)
- Passive income runs server-side (secure, no client exploit possible)
- All progress persists across sessions via DataStore

---

## 🇫🇷 Français

### Ce que cette feature ajoute

Un panneau avec 5 générateurs passifs qui produisent des coins par seconde **automatiquement**, même quand le joueur ne clique pas :
- Générateur 1 : starter pas cher (petit coins/sec)
- Générateur 2, 3, 4, 5 : de plus en plus chers mais de plus en plus productifs

Chaque générateur peut être acheté plusieurs fois (empilable). Le coût augmente à chaque achat avec la formule standard des idle games : `baseCost × 1.15^owned`.

Le total de coins/sec s'update en temps réel dans le header du panneau.

### Pourquoi c'est important

- Introduit la **progression idle** — le jeu te récompense même quand t'es AFK
- Crée une **deuxième boucle** en plus du clic : achète des générateurs → gagne passivement → achète plus d'upgrades → achète plus de générateurs
- **Fondation du genre idle/incrémental** — à partir d'ici, le jeu "se joue tout seul"
- Augmente massivement la durée de session — les joueurs reviennent voir combien ils ont gagné pendant la nuit

### Prérequis

- ✅ **P1 MVP-Clicker** installé en premier
- ✅ **DAY2-Upgrade-Shop** installé (cette feature s'appuie sur les deux)

### Fichiers dans ce dossier

- **`Main.lua`** → colle dans `ServerScriptService` (en tant que `Script`) — remplace le Main.lua précédent, gère maintenant les générateurs côté serveur
- **`ClickHandler.lua`** → colle dans `StarterPlayer` → `StarterPlayerScripts` (en tant que `LocalScript`) — identique à DAY2
- **`GeneratorsUI.lua`** → colle dans `StarterPlayer` → `StarterPlayerScripts` (en tant que NOUVEAU `LocalScript`) — panneau dédié aux générateurs

### Comment tester

1. Sauvegarde les 3 scripts
2. Appuie sur **▶️ Play** dans Studio
3. Clic sur le bouton 🏭 GÉNÉRATEURS → le panneau générateurs s'ouvre
4. Achète ton premier générateur → regarde tes coins monter automatiquement chaque seconde
5. Achète plus → le rythme coins/sec augmente
6. Laisse le jeu tourner → reviens → les coins se sont accumulés

### 🎥 Regarde la vidéo

**TikTok Partie 3 :** [https://vm.tiktok.com/ZN8LQrpYK/](https://www.tiktok.com/@kevinpasflamboyant008)

### Notes

- Les générateurs s'empilent (achète autant que tu veux de chaque)
- Formule de coût : `baseCost × 1.15^owned` (multiplicateur idle standard)
- Le revenu passif tourne côté serveur (sécurisé, pas d'exploit client possible)
- Toute la progression persiste entre sessions via DataStore

---

**➡️ Next / Suivant : DAY4 — Prestige System (coming soon)**
