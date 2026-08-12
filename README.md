# 🎮 Roblox Idle Clicker — Devlog

Building a Roblox idle clicker game from scratch — full code, step by step, published progressively on TikTok.

**Watch the devlog series on TikTok:** [@ton_username_tiktok](https://www.tiktok.com/@ton_username_tiktok)

---

## 📖 What is this?

A complete, working idle/clicker game in Roblox — coded from zero, with the full code available for free. Each folder in this repo matches a TikTok video (Part 1, Part 2, etc.), so you can follow along and reproduce the exact same game step by step.

Perfect if you're:
- 🎮 Learning Roblox development
- 💻 Learning Lua for the first time  
- 🎯 Wanting a working reference for idle game mechanics
- 🚀 Building your own Roblox game

---

## 🗂️ Repository Structure

Each folder = one TikTok video = one game feature.

| Folder | Feature | TikTok Part |
|--------|---------|-------------|
| `P1 MVP-Clicker/` | Click button + coins + auto-save | Part 1 |
| *(more coming as videos drop)* | Upgrades, generators, prestige, animations, sounds... | Parts 2-8+ |

---

## 🚀 How to use the code

### Step 1 — Setup Roblox Studio

1. Open **Roblox Studio**
2. **File** → **New** → **Baseplate**
3. **Home** → **Game Settings** → **Security** → check **"Enable Studio Access to API Services"** ✅ (required for save system)

### Step 2 — Copy the scripts

For each folder:

- **`Main.lua`** → paste inside **ServerScriptService** (as a `Script`)
- **`ClickHandler.lua`** → paste inside **StarterPlayer** → **StarterPlayerScripts** (as a `LocalScript`)

### Step 3 — Test

Hit **▶️ Play** in Studio → click the button → watch your coins go up!

---

## 🛠️ Tech Stack

- **Roblox Studio**
- **Lua**
- `DataStoreService` (auto-save)
- `RemoteEvents` (client ↔ server communication)
- `leaderstats` (top-right coin display)

---

## 📅 Roadmap

- [x] **Part 1** — MVP: click button + auto-save
- [ ] **Part 2** — Upgrade shop (5 upgrades to boost click power)
- [ ] **Part 3** — Passive generators (idle income)
- [ ] **Part 4** — Prestige system (reset for permanent multiplier)
- [ ] **Part 5** — Number formatting (1K, 1M, 1B, T...)
- [ ] **Part 6** — Click animation + floating coins
- [ ] **Part 7** — Sounds (click, purchase, prestige)
- [ ] **Part 8+** — UI polish, particles, milestones, player titles...

---

## 💬 Questions / Feedback?

- Drop a comment on the TikTok video
- Open an [Issue](../../issues) on this repo
- DM me on TikTok

---

## ⚠️ Disclaimer

This code is provided **as-is** for learning purposes. Free to use in your own projects (commercial or not). If you make something cool with it, tag me — I'd love to see!

---

**Made with ❤️ by [FlamBoiLeCode](https://github.com/FlamBoiLeCode)**
