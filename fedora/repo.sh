#!/bin/bash

dnf config-manager setopt max_parallel_downloads=10 timeout=5 retries=1
dnf copr enable -y codifryed/CoolerControl
dnf copr enable -y monkeygold/nautilus-open-any-terminal
dnf copr enable -y peterwu/rendezvous
dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --refresh -y
