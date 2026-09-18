#!/bin/bash

rm ~/.config/systemd/user/hyprland-session.target.wants/dms.service
systemctl --user disable dms.service
systemctl --user enable dms.service
