#!/bin/bash

dnf install -y gdm gnome-shell gnome-console nautilus gnome-control-center xdg-desktop-portal-gnome spice-vdagent qemu-guest-agent gnome-software
systemctl set-default graphical.target
systemctl enable gdm
systemctl enable --now qemu-guest-agent
