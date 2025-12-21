#!/bin/bash

# Restart script for Hyprland and related services
# Bind: $mainMod CTRL + W

echo "Restarting Hyprland services..."

# Kill and restart DMS (DankMaterialShell)
dms kill
sleep 1
dms run &

# swww disabled - DMS handles wallpapers

# Restart clipboard manager if running
if pgrep wl-paste > /dev/null; then
    pkill wl-paste
    sleep 1
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
fi

# Reload Hyprland config
hyprctl reload

echo "Restart complete!"
