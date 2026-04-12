#!/data/data/com.termux/files/usr/bin/bash

clear

# ===== Banner =====
base64 -d <<< "ICBfICAgXyAgICAgICBfX19fXyBfICAgICAgICAgICAgICAgICAKIHwgXCB8IHwgICAgIC8gX19fX3wgfCAgICAgICAgICAgICAgICAKIHwgIFx8IHwgX19ffCAoX19fIHwgfCBfX18gIF9fXyBfIF9fICAKIHwgLiBgIHwvIF8gXFxfX18gXHwgfC8gXyBcLyBfIFwgJ18gXCAKIHwgfFwgIHwgKF8pIHxfX18pIHwgfCAgX18vICBfXy8gfF8pIHwKIHxffF9cX3xcX19fL19fX19fL3xffFxfX198XF9fX3wgLl9fLyAKIHxfXyAgIF9ffCAgICAgICAgICAgICAgICAgICAgIHwgfCAgICAKICAgIHwgfCBfX18gXyBfXyBfIF9fIF9fXyAgXyAgIHxffCAgX18KICAgIHwgfC8gXyBcICdfX3wgJ18gYCBfIFx8IHwgfCBcIFwvIC8KICAgIHwgfCAgX18vIHwgIHwgfCB8IHwgfCB8IHxffCB8PiAgPCAKICAgIHxffFxfX198X3wgIHxffCB8X3wgfF98XF9fLF8vXy9cX1w="

echo ""
echo "[+] xenoZ0x"
sleep 1

echo "[+] Starting setup..."

# ===== Install SoX =====
if ! command -v play >/dev/null 2>&1; then
    pkg install sox -y > /dev/null 2>&1
fi

echo "[+] Ready ✔"
sleep 1

# ===== Create NoSleep script =====
cat << 'EOF' > "$HOME/NoSleep.sh"
#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock

echo "[+] Anti-sleep service started"

nohup bash -c "
while true; do
    play -n -c1 synth sin gain -120
    sleep 1
done
" > /dev/null 2>&1 &

echo $! > "$HOME/nosleep.pid"

sleep 1

echo "[+] Running in background ✔"
echo "[+] PID: $(cat $HOME/nosleep.pid)"

echo ""
echo "[+] ps check:"
ps -p $(cat $HOME/nosleep.pid) -o pid,cmd

echo ""
echo "[+] pgrep check:"
pgrep -a play
EOF

chmod +x "$HOME/NoSleep.sh"

# ===== NS command =====
BIN_NS="$PREFIX/bin/NS"

cat << 'EOF' > "$BIN_NS"
#!/data/data/com.termux/files/usr/bin/bash
bash "$HOME/NoSleep.sh"
EOF

chmod +x "$BIN_NS"

# ===== NS-Stop command =====
BIN_STOP="$PREFIX/bin/NS-Stop"

cat << 'EOF' > "$BIN_STOP"
#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Stopping NoSleep service..."

if [ -f "$HOME/nosleep.pid" ]; then
    kill "$(cat $HOME/nosleep.pid)" 2>/dev/null
    rm -f "$HOME/nosleep.pid"
fi

pkill -f "play -n -c1 synth" 2>/dev/null
pkill play 2>/dev/null

termux-wake-unlock 2>/dev/null

echo "[+] Service stopped ✔"
EOF

chmod +x "$BIN_STOP"

echo "[+] NS command installed ✔"
echo "[+] NS-Stop command installed ✔"

echo "[+] Done!"
echo "[+] Run: NS"
echo "[+] Stop: NS-Stop"

# Cleanup installer
rm -f "$0"
