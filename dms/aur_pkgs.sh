#!/bin/bash

AUR_PKGS=(
    brave-bin
    heroic-games-launcher-bin
    hypr-kdeconnect-fix-git
    payload-dumper-go-bin
    protonup-qt-bin
    rustdesk-bin
    shelly-bin
)

paru -S --noconfirm --needed "${AUR_PKGS[@]}"
