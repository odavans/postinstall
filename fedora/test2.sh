#!/bin/bash

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "timeout=5" >> /etc/dnf/dnf.conf
echo "retries=1" >> /etc/dnf/dnf.conf
dnf install -y fedora-workstation-repositories
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y dnf-plugins-core
dnf copr enable -y codifryed/CoolerControl
dnf copr enable -y peterwu/rendezvous
dnf makecache
dnf update -y
dnf install -y adw-gtk3-theme android-tools baobab bibata-cursor-themes coolercontrol evince f44-backgrounds-gnome fedora-workstation-backgrounds file-roller fish gamemode gamescope gcc gnome-backgrounds gnome-calculator gnome-disk-utility gnome-extensions-app gnome-logs gnome-system-monitor gnome-text-editor gnome-tweaks grsync liquidctl lm_sensors loupe make mangohud papirus-icon-theme steam 

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

getent group plugdev || groupadd plugdev
usermod -aG plugdev "$USER_NAME"

chsh -s /usr/bin/fish "$USER_NAME"

sensors-detect --auto

systemctl enable coolercontrold
