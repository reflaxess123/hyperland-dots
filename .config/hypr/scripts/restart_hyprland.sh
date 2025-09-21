#!/bin/bash

# Restart script for Hyprland and related services
# Bind: $mainMod CTRL + W

echo "Restarting Hyprland services..."

# Kill and restart Waybar
pkill waybar
sleep 1
waybar &

# Kill and restart other background processes if running
pkill hyprpaper
sleep 1
hyprpaper &

# Restart notification daemon if running
if pgrep mako > /dev/null; then
    pkill mako
    sleep 1
    mako &
fi

# Restart clipboard manager if running
if pgrep wl-paste > /dev/null; then
    pkill wl-paste
    sleep 1
    wl-paste --watch cliphist store &
fi

# Reload Hyprland config
hyprctl reload

echo "Restart complete!"