#!/bin/bash

echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "timeout=5" >> /etc/dnf/dnf.conf
echo "retries=1" >> /etc/dnf/dnf.conf
dnf install -y fedora-workstation-repositories
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y dnf-plugins-core
dnf copr enable -y codifryed/CoolerControl
dnf copr enable -y monkeygold/nautilus-open-any-terminal
dnf copr enable -y peterwu/rendezvous
dnf makecache
dnf update -y
