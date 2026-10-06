#!/bin/bash

sudo dnf install -y gdm gnome-shell gnome-console nautilus gnome-control-center xdg-desktop-portal-gnome spice-vdagent qemu-guest-agent gnome-software
sudo systemctl set-default graphical.target
sudo systemctl enable gdm
sudo systemctl enable --now qemu-guest-agent
