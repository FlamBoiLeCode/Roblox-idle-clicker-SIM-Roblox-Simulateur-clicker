✨ Day 6 — Click Animation (Feedback satisfying)

**🇬🇧 [English](#-english) | 🇫🇷 [Français](#-français)**

---

## 🇬🇧 English

### What this feature adds

Two visual feedback effects when you click the CLIQUER button:

1. **Button bounce animation** — the button shrinks briefly then grows back with a smooth "Back" easing effect (way better than the old task.wait(0.05) sec twitch)
2. **Floating coin "+X"** — a yellow "+X" label appears on the button, floats upward and fades out over 1 second (X = actual gain based on click power × prestige multiplier, formatted with NumberFormatter)

Combined = every click feels **satisfying and rewarding**, especially when spam-clicking (multiple "+X" trail upward at the same time).

### Why it matters

- **Dopamine feedback** = the core of idle games. Without visual feedback, clicking = boring after 10 sec
- **Games like Cookie Clicker prove it** — visual click feedback is what makes players "one more click" for hours
- **Sets up premium feel** = your game starts looking pro, not amateur
- **Base for future effects** — same TweenService technique will power sounds (Feature 4.3), panel animations (Feature 4.4), particles (Feature 4.5), etc.

### Prerequisites

- ✅ **P1 MVP-Clicker** installed
- ✅ **DAY2-Upgrade-Shop** installed
- ✅ **DAY3-Generators** installed
- ✅ **DAY4-Prestige-System** installed
- ✅ **DAY5-Number-Formatter** installed (NumberFormatter ModuleScript required for the floating coin text)

### Files in this folder

- **`Main.lua`** → paste inside `ServerScriptService` (as a `Script`) — replaces DAY5 Main.lua. Adds the `ClickResultEvent` RemoteEvent + FireClient to send the gain to the client for the floating animation
- **`ClickHandler.lua`** → paste inside `StarterPlayer` → `StarterPlayerScripts` (as a `LocalScript`) — replaces DAY5 ClickHandler.lua. Adds `TweenService`, `showFloatingCoin()` function, and TweenService animation on the click button

> ⚠️ **Note about other scripts:** `NumberFormatter`, `GeneratorsUI` and `PrestigeUI` haven't changed since DAY5. If you're coming from DAY5, keep your existing files. If you're jumping straight to DAY6, grab them from the `DAY5-Number-Formatter/` folder.

### Test it

1. Save all scripts
2. Hit **▶️ Play** in Studio
3. Click the CLIQUER button → button bounces smoothly + yellow "+1" floats upward + fades
4. Buy an upgrade → click again → "+2" or "+5" floats (scales with click power)
5. Spam click → multiple "+X" trail upward at the same time = very satisfying

### 🎥 Watch the video

**TikTok Part 6:** [https://vm.tiktok.com/ZN8FDQ9YT/](https://www.tiktok.com/@kevinpasflamboyant008)

### Technical notes

- The gain is calculated **server-side** (secure — no client exploit possible)
- The server sends the calculated gain to the client via `ClickResultEvent:FireClient(player, gain)`
- The client only handles the visual animation (`showFloatingCoin(amount)`)
- Button animation uses **TweenService** with `Enum.EasingStyle.Back` for a "premium" bounce
- All floating labels auto-destroy after 1 second (no memory leak)

---

## 🇫🇷 Français

### Ce que cette feature ajoute

Deux effets visuels de feedback quand tu cliques sur le bouton CLIQUER :

1. **Animation rebond du bouton** — le bouton rétrécit brièvement puis regrossit avec un effet "Back" smooth (bien mieux que l'ancien task.wait(0.05) sec saccadé)
2. **Coin flottant "+X"** — un label jaune "+X" apparaît sur le bouton, monte et disparaît en fondu en 1 seconde (X = gain réel basé sur clic power × multiplicateur prestige, formaté via NumberFormatter)

Combiné = chaque clic donne une **sensation satisfaisante et gratifiante**, surtout en spam-clic (plusieurs "+X" défilent vers le haut en même temps).

### Pourquoi c'est important

- **Feedback dopamine** = le cœur des idle games. Sans feedback visuel, cliquer = ennuyeux après 10 sec
- **Les jeux comme Cookie Clicker le prouvent** — le feedback visuel de clic est ce qui fait "encore un clic" pendant des heures
- **Prépare la sensation premium** = ton jeu commence à avoir l'air pro, pas amateur
- **Base pour les futurs effets** — la même technique TweenService sera utilisée pour les sons (Feature 4.3), animations de panneaux (Feature 4.4), particules (Feature 4.5), etc.

### Prérequis

- ✅ **P1 MVP-Clicker** installé
- ✅ **DAY2-Upgrade-Shop** installé
- ✅ **DAY3-Generators** installé
- ✅ **DAY4-Prestige-System** installé
- ✅ **DAY5-Number-Formatter** installé (le ModuleScript NumberFormatter est requis pour le texte du coin flottant)

### Fichiers dans ce dossier

- **`Main.lua`** → colle dans `ServerScriptService` (en tant que `Script`) — remplace le Main.lua de DAY5. Ajoute le RemoteEvent `ClickResultEvent` + FireClient pour envoyer le gain au client pour l'animation flottante
- **`ClickHandler.lua`** → colle dans `StarterPlayer` → `StarterPlayerScripts` (en tant que `LocalScript`) — remplace le ClickHandler.lua de DAY5. Ajoute `TweenService`, la fonction `showFloatingCoin()`, et l'animation TweenService sur le bouton clic

> ⚠️ **Note sur les autres scripts :** `NumberFormatter`, `GeneratorsUI` et `PrestigeUI` n'ont pas changé depuis DAY5. Si tu viens de DAY5, garde tes fichiers existants. Si tu sautes directement à DAY6, récupère-les depuis le dossier `DAY5-Number-Formatter/`.

### Comment tester

1. Sauvegarde tous les scripts
2. Appuie sur **▶️ Play** dans Studio
3. Clique sur le bouton CLIQUER → bouton rebondit smoothly + "+1" jaune monte + fade
4. Achète un upgrade → reclique → "+2" ou "+5" flotte (adapte au clic power)
5. Spam clic → plusieurs "+X" défilent vers le haut en même temps = très satisfaisant

### 🎥 Regarde la vidéo

**TikTok Partie 6 :** [https://vm.tiktok.com/ZN8FDQ9YT/](https://www.tiktok.com/@kevinpasflamboyant008)

### Notes techniques

- Le gain est calculé **côté serveur** (sécurisé — aucun exploit client possible)
- Le serveur envoie le gain calculé au client via `ClickResultEvent:FireClient(player, gain)`
- Le client gère uniquement l'animation visuelle (`showFloatingCoin(amount)`)
- L'animation du bouton utilise **TweenService** avec `Enum.EasingStyle.Back` pour un rebond "premium"
- Tous les labels flottants s'auto-détruisent après 1 seconde (pas de fuite mémoire)

---

**➡️ Next / Suivant : DAY7 — Sounds (click sound + purchase ka-ching + prestige whoosh)**
