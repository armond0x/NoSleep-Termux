# NoSleep — Termux Anti-Sleep Service

> Keep your Android device awake silently using a looped sub-audible tone — no root required.

---

## 📖 Overview

**NoSleep** is a lightweight Bash script for [Termux](https://termux.dev) that prevents your Android device from sleeping by continuously playing a near-silent audio tone in the background. It uses `sox` to generate a sine wave at `-120dB` gain — completely inaudible — which keeps the audio subsystem active and the screen/CPU from idling.

Useful for:
- Keeping a Termux server or script running overnight
- Preventing session timeouts during long downloads or compilations
- Maintaining a persistent SSH/VNC session without `termux-wake-lock` alone

---

## ⚙️ How It Works

| Step | What happens |
|------|-------------|
| `setup.sh` | Installs `sox` if missing, generates `NoSleep.sh`, then self-deletes |
| `NoSleep.sh` | Acquires `termux-wake-lock`, spawns a background `play` loop via `nohup` |
| `play` loop | Generates a `-120dB` sine tone every second — silent but audio-active |

---

## 📦 Requirements

- **Termux** (F-Droid build recommended)
- **Termux:API** app installed (for `termux-wake-lock`)
- `sox` package (auto-installed by setup script if missing)

---

## 🚀 Usage

### 1. Clone or download

```bash
git clone https://github.com/xenoZ0x/NoSleep-Termux.git
cd NoSleep-Termux
```

### 2. Run the setup script

```bash
bash setup.sh
```

This will:
- Install `sox` if not already present
- Generate `NoSleep.sh` in the current directory
- Self-delete after setup

### 3. Start the anti-sleep service

```bash
./NoSleep.sh
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

---

## 🛑 Stopping the Service

```bash
# Kill by process name
pkill play

# Or kill by PID shown at startup
kill <PID>

# Release wake lock
termux-wake-unlock
```

---

## 📁 File Structure

```
nowake/
├── setup.sh      # Setup & generator script (self-deletes after run)
├── NoSleep.sh         # Generated anti-sleep runner (created by setup.sh)
└── README.md
```

---

## ⚠️ Notes

- The `-120dB` gain makes the tone completely inaudible on virtually all devices.
- `nohup` ensures the background process survives if the Termux session is minimized.
- `termux-wake-lock` prevents Android from killing the process due to Doze mode.
- For best results, also disable battery optimization for Termux in Android settings:
  `Settings → Apps → Termux → Battery → Unrestricted`

---

## 🧠 Credits

Built by **xenoZ0x**

---

## 📄 License

MIT License — free to use, modify, and distribute.
