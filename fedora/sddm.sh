#!/bin/bash

sudo dnf install -y sddm
sudo systemctl set-default graphical.target
sudo systemctl enable sddm
