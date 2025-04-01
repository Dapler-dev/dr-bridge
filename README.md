# dr-bridge

**dr-bridge** is a universal framework bridge for FiveM, designed to seamlessly integrate **QBCore**, **ESX**, and other frameworks.  
It allows developers to write universal scripts that work across multiple FiveM frameworks without needing to rewrite code for each.

---

## ✨ Features

- **Framework Compatibility** – Supports QBCore and ESX (extensible to others)  
- **Unified API** – Simplifies access to player data, money, jobs, items, etc.  
- **Client & Server Functions** – Tools for both sides of the script  
- **Exportable Functions** – Use with `exports` in other scripts

---

## 📦 Installation

**1.** Download or clone this repository  
**2.** Place the `dr-bridge` folder into your `resources/` directory  
**3.** Add the following to your `server.cfg`:

```
ensure dr-bridge
```

**4.** Restart your server

---

## ⚙️ Configuration

In `config.lua`:

```
Config.Debug = true -- Set to false in production
```

---

## 🧰 Usage

### 🔹 Client-side API

- `GetPlayerData()` – Get local player's full data  
- `GetJob()` – Get the player's current job  
- `GetMoney(account)` – Get money from a specific account  
- `HasItem(item, count)` – Check if player has item  
- `Notify(text, type)` – Show notification

### 🔸 Server-side API

- `GetPlayer(source)` – Get player by source  
- `GetJob(source)` – Get player's job  
- `SetJob(source, job, grade)` – Change player's job  
- `GetMoney(source, account)` – Get player balance  
- `AddMoney(source, amount, account)` – Add money

---

## 🔁 Exports

### ✅ Client Example

```lua
local playerData = exports['dr-bridge']:GetPlayerData()
```

### ✅ Server Example

```lua
local playerJob = exports['dr-bridge']:GetJob(source)
```

---

## 📚 Documentation

Full documentation available at:  
🗾 **https://docs.dapler.eu/scripts/bridge**

---

## 💬 Community & More Scripts

Join the community and discover more open source scripts by DapleR:  
🌐 **https://discord.gg/C9D4jePKT5**

---

## 📜 License

`dr-bridge` is an open-source project. You are free to modify and use the code, under these conditions:

- **Attribution**: Must always be released as `dr-bridge` by **DapleR**.  
- **Modification**: You may modify it, but must not re-release it under a different name or claim ownership.  
- **No Official Support**: Provided as-is, with no support included.
