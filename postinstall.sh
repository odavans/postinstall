#!/bin/bash

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

PKGS=(
    android-tools
    android-udev
    archlinux-appstream-data
    breeze-cursors
    brotli
    cabextract
    caja
    cpio
    crow-translate
    engrampa
    fish
    flatpak
    galculator
    gamemode
    gedit
    gedit-plugins
    geoclue
    gnome-keyring
    gst-libav
    gst-plugins-bad
    gst-plugins-ugly
    gvfs
    gvfs-mtp
    kdeconnect
    lib32-gamemode
    lib32-mangohud
    lib32-nvidia-utils
    libappindicator
    libayatana-appindicator
    libreoffice-fresh
    lightdm
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings
    linux-zen-headers
    liquidctl
    mangohud
    nano
    network-manager-applet
    nvidia-open-dkms
    nvidia-settings
    nvidia-utils
    onnxruntime-cpu
    os-prober
    p7zip
    papirus-icon-theme
    parole
    pavucontrol
    pkgfile
    python
    qbittorrent
    qt5-base
    qt6-tools
    rpm-tools
    sshfs
    steam
    telegram-desktop
    tesseract-data-eng
    tesseract-data-rus
    tesseract-data-ukr
    thunar-archive-plugin
    thunar-media-tags-plugin
    unace
    unrar
    unzip
    viewnior
    vivaldi
    vivaldi-ffmpeg-codecs
    webkit2gtk-4.1
    webkitgtk-6.0
    xcape
    xclip
    xdg-desktop-portal
    xdg-user-dirs-gtk
    xfce4
    xfce4-pulseaudio-plugin
    xfce4-screensaver
    xfce4-screenshooter
    xfce4-taskmanager
    xfce4-whiskermenu-plugin
    xfce4-xkb-plugin
    xorg
    xorg-fonts-misc
)

pacman -S --noconfirm --needed "${PKGS[@]}"

AUR_PKGS=(
    coolercontrol-bin
    coolercontrold-bin
    heroic-games-launcher-bin
    matcha-gtk-theme
    menulibre
    payload-dumper-go-bin
    protonup-qt-bin
    rustdesk-bin
    shelly-bin
)

sudo -u "$USER_NAME" paru -S --noconfirm --needed "${AUR_PKGS[@]}"

USER_DIRS=(
    "$USER_HOME/.config/MangoHud"
    "$USER_HOME/.config/autostart"
    "$USER_HOME/.local/bin"
)

sudo -u "$USER_NAME" mkdir -p "${USER_DIRS[@]}"

sudo -u "$USER_NAME" cp /usr/share/applications/org.coolercontrol.CoolerControl.desktop "$USER_HOME/.config/autostart/org.coolercontrol.CoolerControl.desktop"

sudo -u "$USER_NAME" curl -fsSL \
    https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf \
    -o "$USER_HOME/.config/MangoHud/MangoHud.conf"

CONF_FILE="$USER_HOME/.config/MangoHud/MangoHud.conf"
if [[ -f "$CONF_FILE" ]]; then
    sudo -u "$USER_NAME" sed -i \
        -e 's/^#\s*gpu_temp/gpu_temp/' \
        -e 's/^#\s*gpu_fan/gpu_fan/' \
        -e 's/^#\s*cpu_temp/cpu_temp/' \
        -e 's/^#\s*position=top-left/position=top-left/' \
        -e 's/^#\s*toggle_hud=Shift_R+F12/toggle_hud=Shift_R+F12/' \
        -e 's/^#\s*toggle_hud_position=Shift_R+F1/toggle_hud_position=Shift_R+F1/' \
        "$CONF_FILE"
fi

cat <<EOF > /etc/polkit-1/rules.d/10-udisks2.rules
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
         action.id == "org.freedesktop.udisks2.filesystem-mount") &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

cat <<EOF > /etc/udev/rules.d/50-keychron.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="373b", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", MODE="0666"
EOF

cat <<EOF > /etc/udev/rules.d/51-android.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0666", GROUP="plugdev"
EOF

groupadd -f plugdev
gpasswd -a "$USER_NAME" plugdev

sensors-detect --auto > /dev/null
systemctl enable coolercontrold
systemctl enable lightdm

cat <<EOF > /etc/modprobe.d/nvidia.conf
options nvidia_drm modeset=1
options nvidia NVreg_EnableResizableBar=1
EOF

mkinitcpio -P

if [ -f /etc/default/grub ]; then
    sed -i 's/^#\(GRUB_DISABLE_OS_PROBER=false\)/\1/' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "ntsync" > /etc/modules-load.d/ntsync.conf

RESUME_SCRIPT="$USER_HOME/.local/bin/resume-fix.sh"
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
chown "$USER_NAME:$USER_NAME" "$RESUME_SCRIPT"

AUTOSTART_ENTRY="$USER_HOME/.config/autostart/resume-fix.desktop"
cat <<EOF > "$AUTOSTART_ENTRY"
[Desktop Entry]
Type=Application
Name=resume-fix
Exec=$RESUME_SCRIPT
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
chown "$USER_NAME:$USER_NAME" "$AUTOSTART_ENTRY"

pkgfile -u
systemctl enable --now pkgfile-update.timer

chsh -s /usr/bin/fish "$USER_NAME"

FISH_CONF_DIR="$USER_HOME/.config/fish"
sudo -u "$USER_NAME" mkdir -p "$FISH_CONF_DIR"
sudo -u "$USER_NAME" touch "$FISH_CONF_DIR/config.fish"

if ! sudo -u "$USER_NAME" grep -q "set -g fish_greeting" "$FISH_CONF_DIR/config.fish"; then
    echo "set -g fish_greeting" | sudo -u "$USER_NAME" tee -a "$FISH_CONF_DIR/config.fish" > /dev/null
fi
