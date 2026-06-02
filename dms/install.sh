#!/bin/bash

REPO_DIR="$HOME/.local/share/postinstall"

mkdir -p "$(dirname "$REPO_DIR")"

git clone https://github.com/odavans/postinstall.git "$REPO_DIR"

cd "$REPO_DIR/dms"

sudo -v

sudo bash pkgs.sh

bash paru.sh

bash aur_pkgs.sh

sudo USER_NAME="$(whoami)" bash sudo.sh

bash user.sh

cd ~

rm -rf "$REPO_DIR"
