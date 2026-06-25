#!/bin/bash

AUR_PKGS=(
    coolercontrol-bin
    heroic-games-launcher-bin
    matcha-gtk-theme
    menulibre
    payload-dumper-go-bin
    protonup-qt-bin
    rustdesk-bin
    shelly-bin
)

paru -S --noconfirm --needed "${AUR_PKGS[@]}"
