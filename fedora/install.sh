#!/bin/bash

REPO_DIR="$HOME/.local/share/postinstall"

mkdir -p "$(dirname "$REPO_DIR")"

git clone https://github.com/odavans/postinstall.git "$REPO_DIR"

cd "$REPO_DIR/fedora"

sudo -v

sudo bash repo.sh

sudo bash sudo.sh

bash user.sh

bash flatpak.sh

cd ~

rm -rf "$REPO_DIR"
