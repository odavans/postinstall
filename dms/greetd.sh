#!/bin/bash

sed -i 's|command = "agreety --cmd /bin/sh"|command = "/usr/bin/dms-greeter --command niri"|' /etc/greetd/config.toml
systemctl enable greetd
