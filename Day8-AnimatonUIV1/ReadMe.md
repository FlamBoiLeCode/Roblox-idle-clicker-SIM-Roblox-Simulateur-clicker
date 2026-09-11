# DAY 8 — Tween UI (Panneaux animés)

## 🇬🇧 English

**What this adds:**
- Shop panel slides in from the right (0.3s)
- Generators panel slides in from the left (0.3s)
- Prestige panel scales up + fades in from center (0.4s Back easing) — premium "boom" effect
- Every panel opens/closes with a smooth TweenService animation (no more instant pop)

**Prerequisites:** DAY 1 to DAY 7 completed (base game + shop + generators + prestige + number formatter + click animation + sounds).

**Studio Setup:** No new setup needed. Just replace the 3 LocalScripts.

**Files modified:**
- `ClickHandler.lua` → V4.4 (adds shop slide-right animation)
- `GeneratorsUI.lua` → V4.4 (adds generators slide-left animation)
- `PrestigeUI.lua` → V4.4 (adds prestige scale+fade animation)

Unchanged from DAY 7: `Main.lua`, `NumberFormatter.lua`, `Sounds` folder.

**Test:**
1. Open Shop → smooth slide from the right
2. Open Generators → smooth slide from the left
3. Open Prestige → scale + fade "boom" from center
4. Close each → reverse animation

**Technical note — Why 3 different animations?**
- Shop and Generators use slide (fast, smooth, informative)
- Prestige uses scale+fade for extra "epic" feel (rare action = deserves more drama)
- All animations use TweenService for smooth 60fps performance

---

## 🇫🇷 Français

**Ce que ça ajoute :**
- Panneau Boutique slide depuis la droite (0.3s)
- Panneau Générateurs slide depuis la gauche (0.3s)
- Panneau Prestige scale + fade in depuis le centre (0.4s Back easing) — effet "boom" premium
- Chaque panneau s'ouvre/ferme avec une animation TweenService smooth (fini les pop instantanés)

**Prérequis :** DAY 1 à DAY 7 terminés (jeu de base + boutique + générateurs + prestige + formatage nombres + animation clic + sons).

**Setup Studio :** Aucun nouveau setup nécessaire. Juste remplacer les 3 LocalScripts.

**Fichiers modifiés :**
- `ClickHandler.lua` → V4.4 (ajoute animation slide-droite boutique)
- `GeneratorsUI.lua` → V4.4 (ajoute animation slide-gauche générateurs)
- `PrestigeUI.lua` → V4.4 (ajoute animation scale+fade prestige)

Inchangés depuis DAY 7 : `Main.lua`, `NumberFormatter.lua`, dossier `Sounds`.

**Test :**
1. Ouvre Boutique → slide fluide depuis la droite
2. Ouvre Générateurs → slide fluide depuis la gauche
3. Ouvre Prestige → scale + fade "boom" depuis le centre
4. Ferme chacun → animation inversée

**Note technique — Pourquoi 3 animations différentes ?**
- Boutique et Générateurs utilisent le slide (rapide, fluide, informatif)
- Prestige utilise scale+fade pour un effet plus "épique" (action rare = mérite plus de drama)
- Toutes les animations utilisent TweenService pour un rendu 60fps smooth
