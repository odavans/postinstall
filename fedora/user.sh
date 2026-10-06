#!/bin/bash

USER_DIRS=(
    "$HOME/.config/autostart"
    "$HOME/.config/fish"
    "$HOME/.config/MangoHud"
    "$HOME/.local/share/Steam"
    "$HOME/.var/app/org.telegram.desktop/data/TelegramDesktop"
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

echo "set -g fish_greeting" >> "$HOME/.config/fish/config.fish"

echo "unShaderBackgroundProcessingThreads 12" > "$HOME/.local/share/Steam/steam_dev.cfg"

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

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
