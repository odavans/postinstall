#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub \
  io.bassi.Amberol \
  com.brave.Browser \
  org.mozilla.firefox \
  com.github.tchx84.Flatseal \
  com.heroicgameslauncher.hgl \
  io.github.flattool.Ignition \
  org.libreoffice.LibreOffice \
  com.protonvpn.www \
  net.davidotek.pupgui2 \
  org.qbittorrent.qBittorrent \
  com.rustdesk.RustDesk \
  org.telegram.desktop \
  org.videolan.VLC

flatpak override --user --device=dri com.brave.Browser
flatpak override --user --device=dri org.mozilla.firefox
flatpak override --user --device=dri org.videolan.VLC
