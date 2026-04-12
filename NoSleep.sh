#!/data/data/com.termux/files/usr/bin/bash

clear

# ===== Banner =====
base64 -d <<< "ICBfICAgXyAgICAgICBfX19fXyBfICAgICAgICAgICAgICAgICAKIHwgXCB8IHwgICAgIC8gX19f
X3wgfCAgICAgICAgICAgICAgICAKIHwgIFx8IHwgX19ffCAoX19fIHwgfCBfX18gIF9fXyBfIF9f
ICAKIHwgLiBgIHwvIF8gXFxfX18gXHwgfC8gXyBcLyBfIFwgJ18gXCAKIHwgfFwgIHwgKF8pIHxf
X18pIHwgfCAgX18vICBfXy8gfF8pIHwKIHxffF9cX3xcX19fL19fX19fL3xffFxfX198XF9fX3wg
Ll9fLyAKIHxfXyAgIF9ffCAgICAgICAgICAgICAgICAgICAgIHwgfCAgICAKICAgIHwgfCBfX18g
XyBfXyBfIF9fIF9fXyAgXyAgIHxffCAgX18KICAgIHwgfC8gXyBcICdfX3wgJ18gYCBfIFx8IHwg
fCBcIFwvIC8KICAgIHwgfCAgX18vIHwgIHwgfCB8IHwgfCB8IHxffCB8PiAgPCAKICAgIHxffFxf
X198X3wgIHxffCB8X3wgfF98XF9fLF8vXy9cX1w="

echo ""
echo "[+] xenoZ0x"
sleep 1

echo "[+] Starting setup..."

# ===== Install sox =====
if ! command -v play >/dev/null 2>&1; then
    pkg install sox -y > /dev/null 2>&1
fi

echo "[+] Ready ✔"

sleep 1

# ===== Create runner WITHOUT EOF =====
printf '%s\n' \
'#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock

echo "[+] Anti-sleep service started"

nohup bash -c "
while true; do
    play -n -c1 synth sin gain -120
    sleep 1
done
" > /dev/null 2>&1 &

PID=$!

sleep 1

echo "[+] Running in background ✔"
echo "[+] PID: $PID"

echo ""
echo "[+] ps check:"
ps -p $PID -o pid,cmd

echo ""
echo "[+] pgrep check:"
pgrep -a play
' > NoSleep.sh

chmod +x NoSleep.sh

echo "[+] Done!"
echo "[+] Run: ./NoSleep.sh"

rm -f "$0"
