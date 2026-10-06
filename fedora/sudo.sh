#!/bin/bash

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

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

systemctl enable coolercontrold
systemctl enable iwd

echo "ntsync" > /etc/modules-load.d/ntsync.conf

firewall-cmd --permanent --add-service=kdeconnect
