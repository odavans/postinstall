#!/bin/bash

dnf install -y akmod-nvidia android-tools breeze-cursor-theme coolercontrol cups-pk-helper evince file-roller fish gamemode gamescope gcc gnome-calculator gnome-software gnome-text-editor grsync gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gvfs gvfs-mtp i2c-tools iwd kde-connect kernel-devel kernel-headers libva-utils libvirt liquidctl lm_sensors loupe make mangohud nautilus nautilus-open-any-terminal nvidia-vaapi-driver papirus-icon-theme power-profiles-daemon steam virt-manager wl-clipboard xdg-desktop-portal-gnome xdg-user-dirs xorg-x11-drv-nvidia-cuda
dnf swap -y ffmpeg-free ffmpeg --allowerasing
