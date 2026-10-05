#!/bin/bash

REPO_DIR="$HOME/.local/share/postinstall"

mkdir -p "$(dirname "$REPO_DIR")"

git clone https://github.com/odavans/postinstall.git "$REPO_DIR"

cd "$REPO_DIR/fedora"

sudo -v

sudo bash sudo.sh

#bash user.sh

cd ~

rm -rf "$REPO_DIR"
