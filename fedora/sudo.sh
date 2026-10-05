#!/bin/bash

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

sed -i 's/\(metalink=.*\)/\1\&country=PL,DE,CZ,NL/' /etc/yum.repos.d/fedora*.repo
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "fastestmirror=True" >> /etc/dnf/dnf.conf

dnf install -y fedora-workstation-repositories
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled google-chrome
dnf copr enable -y codifryed/CoolerControl
dnf copr enable -y peterwu/rendezvous
dnf makecache
dnf update -y
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf install -y adw-gtk3-theme akmod-nvidia android-tools baobab bibata-cursor-themes coolercontrol evince f44-backgrounds-gnome fedora-workstation-backgrounds file-roller fish flatpak gamemode gamescope gcc gdm gnome-backgrounds gnome-calculator gnome-console gnome-control-center gnome-disk-utility gnome-extensions-app gnome-logs gnome-shell gnome-software gnome-system-monitor gnome-text-editor gnome-tweaks grsync gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly iwd kernel-devel kernel-headers libva-utils libvirt liquidctl lm_sensors loupe make mangohud nautilus NetworkManager-wifi nvidia-vaapi-driver papirus-icon-theme steam virt-manager wl-clipboard xdg-desktop-portal-gnome xorg-x11-drv-nvidia-cuda
akmods --force

cat <<'EOF' > /etc/polkit-1/rules.d/10-udisks2.rules
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
         action.id == "org.freedesktop.udisks2.filesystem-mount") &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

cat <<'EOF' > /etc/udev/rules.d/50-hid.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="373b", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1915", MODE="0666"
EOF

cat <<'EOF' > /etc/udev/rules.d/51-android.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0666", GROUP="plugdev"
EOF

cat <<'EOF' > /etc/NetworkManager/conf.d/archer-c64.conf
[connection]
wifi.powersave = 2
EOF

cat <<'EOF' > /etc/NetworkManager/conf.d/iwd.conf
[device]
wifi.backend=iwd
EOF

getent group plugdev || groupadd plugdev
usermod -aG plugdev "$USER_NAME"
usermod -aG libvirt "$USER_NAME"

chsh -s /usr/bin/fish "$USER_NAME"

sensors-detect --auto

systemctl set-default graphical.target
systemctl enable coolercontrold
systemctl enable gdm
systemctl enable iwd
