# NoSleep — Termux Anti-Sleep Service

> Keep your Android device awake silently using a looped sub-audible tone — no root required.

---

## 📖 Overview

**NoSleep** is a lightweight Bash script for [Termux](https://termux.dev) that prevents your Android device from sleeping by continuously playing a near-silent audio tone in the background. It uses `sox` to generate a sine wave at `-120dB` gain — completely inaudible — which keeps the audio subsystem active and the CPU from idling.

Useful for:
- Keeping a Termux server or script running overnight
- Preventing session timeouts during long downloads or compilations
- Maintaining a persistent SSH/VNC session without relying on `termux-wake-lock` alone

---

## ⚙️ How It Works

| Component | What it does |
|-----------|-------------|
| `NoSleep-Setup.sh` | Installs `sox`, creates `NoSleep.sh`, registers `NS` and `NS-Stop` as global commands, then self-deletes |
| `NoSleep.sh` | Acquires `termux-wake-lock` and spawns the background `play` loop via `nohup` |
| `NS` | Global shortcut command — runs `NoSleep.sh` from anywhere |
| `NS-Stop` | Global shortcut command — kills the service and releases the wake lock |
| `play` loop | Generates a `-120dB` sine tone every second — silent but audio-active |

---

## 📦 Requirements

- **Termux** (F-Droid build recommended)
- **Termux:API** app installed (for `termux-wake-lock` / `termux-wake-unlock`)
- `sox` package — auto-installed by the setup script if missing
---

## 🚀 Usage

### 1. Clone the repo

```bash
git clone https://github.com/xenoZ0x/NoSleep-Termux.git
cd NoSleep-Termux
```

### 2. Run the setup script

```bash
bash NoSleep-Setup.sh
```

This will:
- Install `sox` if not already present
- Create `~/NoSleep.sh`
- Register `NS` and `NS-Stop` as global commands in `$PREFIX/bin`
- Self-delete after setup

### 3. Start the service

```bash
NS
```

**Example output:**
```
[+] Anti-sleep service started
[+] Running in background ✔
[+] PID: 12345

[+] ps check:
  PID CMD
12345 play -n -c1 synth sin gain -120

[+] pgrep check:
12345 play -n -c1 synth sin gain -120
```

### 4. Stop the service

```bash
NS-Stop
```

**Example output:**
```
[+] Stopping NoSleep service...
[+] Service stopped ✔
```

---

## 📁 Repository Structure

```
nosleep/
├── NoSleep-Setup.sh   # One-time setup & installer (self-deletes after run)
└── README.md
```

**After setup, these are created automatically:**

```
~/NoSleep.sh               # Main service script
$PREFIX/bin/NS             # Global start command
$PREFIX/bin/NS-Stop        # Global stop command
~/nosleep.pid              # PID file (created at runtime, auto-removed on stop)
```

---

## ⚠️ Notes

- The `-120dB` gain makes the tone completely inaudible on virtually all devices.
- `nohup` ensures the background process survives if the Termux session is minimized.
- `termux-wake-lock` prevents Android from killing the process due to Doze mode.
- The PID is saved to `~/nosleep.pid` so `NS-Stop` can cleanly terminate the correct process.
- For best results, disable battery optimization for Termux in Android settings:
  `Settings → Apps → Termux → Battery → Unrestricted`

---

## 🧠 Credits

Built by **xenoZ0x**

---

## 📄 License

MIT License — free to use, modify, and distribute.
