#!/bin/bash

AUR_PKGS=(
    coolercontrol-bin
    heroic-games-launcher-bin
    hypr-kdeconnect-fix-git
    nautilus-open-any-terminal
    papirus-folders
    payload-dumper-go-bin
    protonup-qt-bin
    rustdesk-bin
    shelly-bin
)

paru -S --noconfirm --needed "${AUR_PKGS[@]}"
