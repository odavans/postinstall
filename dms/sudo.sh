#!/bin/bash

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
systemctl enable pkgfile-update.timer

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

pkgfile -u

chsh -s /usr/bin/fish "$USER_NAME"
