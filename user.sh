#!/bin/bash

USER_DIRS=(
    "$HOME/.config/MangoHud"
    "$HOME/.config/autostart"
    "$HOME/.local/bin"
)

mkdir -p "${USER_DIRS[@]}"

cp /usr/share/applications/org.coolercontrol.CoolerControl.desktop "$HOME/.config/autostart/"

curl -fsSL https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf -o "$HOME/.config/MangoHud/MangoHud.conf"

CONF_FILE="$HOME/.config/MangoHud/MangoHud.conf"

if [[ -f "$CONF_FILE" ]]; then
    sed -i \
        -e 's/^#\s*gpu_temp/gpu_temp/' \
        -e 's/^#\s*gpu_fan/gpu_fan/' \
        -e 's/^#\s*cpu_temp/cpu_temp/' \
        -e 's/^#\s*position=top-left/position=top-left/' \
        -e 's/^#\s*toggle_hud=Shift_R+F12/toggle_hud=Shift_R+F12/' \
        -e 's/^#\s*toggle_hud_position=Shift_R+F1/toggle_hud_position=Shift_R+F1/' \
        "$CONF_FILE"
fi

RESUME_SCRIPT="$HOME/.local/bin/resume-fix.sh"

cat <<'EOF' > "$RESUME_SCRIPT"
#!/bin/bash
DISPLAY_SAVED="$DISPLAY"
DBUS_SESSION_SAVED="$DBUS_SESSION_BUS_ADDRESS"
XAUTHORITY_SAVED="$XAUTHORITY"

gdbus monitor --system \
  --dest org.freedesktop.login1 \
  --object-path /org/freedesktop/login1 | while read -r line; do
    if [[ "$line" == *"PrepareForSleep (true,)"* ]]; then
        DISPLAY="$DISPLAY_SAVED" \
        DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_SAVED" \
        XAUTHORITY="$XAUTHORITY_SAVED" \
        xfconf-query -c xfwm4 -p /general/use_compositing -s false
    fi
done &

gdbus monitor --session \
  --dest org.xfce.ScreenSaver \
  --object-path /org/xfce/ScreenSaver | while read -r line; do
    if [[ "$line" == *"ActiveChanged (false,)"* ]]; then
        sleep 1
        DISPLAY="$DISPLAY_SAVED" \
        DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_SAVED" \
        XAUTHORITY="$XAUTHORITY_SAVED" \
        xfconf-query -c xfwm4 -p /general/use_compositing -s true
    fi
done &

wait
EOF

chmod +x "$RESUME_SCRIPT"

AUTOSTART_ENTRY="$HOME/.config/autostart/resume-fix.desktop"

cat <<EOF > "$AUTOSTART_ENTRY"
[Desktop Entry]
Type=Application
Name=resume-fix
Exec=$RESUME_SCRIPT
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

FISH_CONF_DIR="$HOME/.config/fish"

mkdir -p "$FISH_CONF_DIR"

touch "$FISH_CONF_DIR/config.fish"

if ! grep -q "set -g fish_greeting" "$FISH_CONF_DIR/config.fish"; then
    echo "set -g fish_greeting" >> "$FISH_CONF_DIR/config.fish"
fi
