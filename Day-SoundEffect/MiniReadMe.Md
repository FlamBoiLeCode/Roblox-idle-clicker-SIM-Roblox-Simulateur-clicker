# DAY 7 — Sounds (Click + Purchase + Prestige)

## 🇬🇧 English

**What this adds:**
- ClickSound on every CLIQUER button press
- PurchaseSound (ka-ching) on every upgrade or generator buy
- PrestigeSound (whoosh) on prestige reset (only if valid)

**Prerequisites:** DAY 1 to DAY 6 completed.

**Studio Setup — Sounds folder:**
1. Right-click **ReplicatedStorage** → Insert Object → **Folder** → rename **Sounds**
2. Inside, insert **3 Sound objects**:

| Sound Name | SoundId | Volume |
|------------|---------|--------|
| ClickSound | `rbxassetid://6895079853` | 0.3 |
| PurchaseSound | `rbxassetid://5852470908` | 0.5 |
| PrestigeSound | `rbxassetid://131886985` | 0.7 |

**Files modified:** `ClickHandler.lua`, `GeneratorsUI.lua`, `PrestigeUI.lua` (add sound references + `:Play()` calls).
Unchanged from DAY 6: `Main.lua`, `NumberFormatter.lua`.

**Test:** Click → soft click. Buy upgrade/generator → ka-ching. Prestige with 100k+ coins → whoosh.

**How to change a sound later:** Explorer → ReplicatedStorage → Sounds → select → Properties → SoundId → paste new `rbxassetid://XXX`. Zero code change.

---

## 🇫🇷 Français

**Ce que ça ajoute :**
- ClickSound à chaque clic sur le bouton CLIQUER
- PurchaseSound (ka-ching) à chaque achat d'upgrade ou de générateur
- PrestigeSound (whoosh) au reset prestige (uniquement si valide)

**Prérequis :** DAY 1 à DAY 6 terminés.

**Setup Studio — Dossier Sounds :**
1. Clic droit sur **ReplicatedStorage** → Insert Object → **Folder** → renomme **Sounds**
2. Dedans, insère **3 Sound objects** :

| Nom du Sound | SoundId | Volume |
|--------------|---------|--------|
| ClickSound | `rbxassetid://6895079853` | 0.3 |
| PurchaseSound | `rbxassetid://5852470908` | 0.5 |
| PrestigeSound | `rbxassetid://131886985` | 0.7 |

**Fichiers modifiés :** `ClickHandler.lua`, `GeneratorsUI.lua`, `PrestigeUI.lua` (ajout des références sound + appels `:Play()`).
Inchangés depuis DAY 6 : `Main.lua`, `NumberFormatter.lua`.

**Test :** Clic → son léger. Achat upgrade/générateur → ka-ching. Prestige avec 100k+ coins → whoosh.

**Changer un son plus tard :** Explorer → ReplicatedStorage → Sounds → sélectionner → Properties → SoundId → coller nouveau `rbxassetid://XXX`. Aucune modif de code.
