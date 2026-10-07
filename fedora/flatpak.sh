#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.heroicgameslauncher.hgl
flatpak install -y flathub com.protonvpn.www
flatpak install -y flathub io.bassi.Amberol
flatpak install -y flathub net.davidotek.pupgui2
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.qbittorrent.qBittorrent
flatpak install -y flathub com.rustdesk.RustDesk
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub org.videolan.VLC
