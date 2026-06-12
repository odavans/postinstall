#!/bin/bash
sudo pacman -S base-devel --noconfirm --needed
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru
