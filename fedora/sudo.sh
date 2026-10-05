#!/bin/bash

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
dnf install -y gdm gnome-shell gnome-console nautilus gnome-control-center gnome-software

systemctl set-default graphical.target
systemctl enable gdm
