#!/bin/bash

USER_DIRS=(
    "$HOME/.config/autostart"
    "$HOME/.config/MangoHud"
    "$HOME/.config/xdg-desktop-portal"
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

cat << 'EOF' > "$HOME/.config/xdg-desktop-portal/portals.conf"
[preferred]
default=gnome;gtk;
org.freedesktop.impl.portal.Access=gtk
org.freedesktop.impl.portal.Notification=gtk
org.freedesktop.impl.portal.Secret=gnome-keyring
org.freedesktop.impl.portal.RemoteDesktop=hypr-kdeconnect
EOF

FISH_CONF_DIR="$HOME/.config/fish"

mkdir -p "$FISH_CONF_DIR"

touch "$FISH_CONF_DIR/config.fish"

if ! grep -q "set -g fish_greeting" "$FISH_CONF_DIR/config.fish"; then
    echo "set -g fish_greeting" >> "$FISH_CONF_DIR/config.fish"
fi

for size in 16x16 22x22 24x24; do
  mkdir -p "$HOME/.local/share/icons/Papirus/$size/symbolic/apps"

  ln -sf \
  /usr/share/icons/hicolor/symbolic/apps/org.coolercontrol.CoolerControl-symbolic.svg \
  "$HOME/.local/share/icons/Papirus/$size/symbolic/apps/org.coolercontrol.CoolerControl-symbolic.svg"
done

for size in 16x16 22x22 24x24; do
  mkdir -p "$HOME/.local/share/icons/Papirus-Light/$size/panel"

  ln -sf /usr/share/icons/Papirus-Light/$size/panel/telegram-panel.svg \
         "$HOME/.local/share/icons/Papirus-Light/$size/panel/org.telegram.desktop-symbolic.svg"

  ln -sf /usr/share/icons/Papirus-Light/$size/panel/telegram-attention-panel.svg \
         "$HOME/.local/share/icons/Papirus-Light/$size/panel/org.telegram.desktop-attention-symbolic.svg"

  ln -sf /usr/share/icons/Papirus-Light/$size/panel/telegram-mute-panel.svg \
         "$HOME/.local/share/icons/Papirus-Light/$size/panel/org.telegram.desktop-mute-symbolic.svg"
done
