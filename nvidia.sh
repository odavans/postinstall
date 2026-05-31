#!/bin/bash

sudo pacman -S --noconfirm lib32-nvidia-utils linux-zen-headers nvidia-open-dkms nvidia-settings nvidia-utils

sudo tee /etc/modprobe.d/nvidia.conf >/dev/null <<EOF
options nvidia_drm modeset=1
options nvidia NVreg_EnableResizableBar=1
EOF

sudo mkinitcpio -P
