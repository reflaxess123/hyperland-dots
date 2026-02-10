#!/bin/bash

# Restart script for Hyprland and related services
# Bind: $mainMod CTRL + W

export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr/ 2>/dev/null | head -1)

echo "Restarting Hyprland services..."

# Restart waybar
pkill waybar 2>/dev/null
sleep 0.5
waybar &disown

# Restart wallpaper
pkill swww-daemon 2>/dev/null
sleep 0.5
swww-daemon &disown
sleep 1
WALLPAPER=$(grep 'swww img' ~/.config/hypr/hyprland.conf | sed 's/.*swww img //' | sed 's/ --.*//' | head -1)
eval swww img "$WALLPAPER" --transition-type none &

# Restart clipboard manager
pkill wl-paste 2>/dev/null
sleep 0.5
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Reload Hyprland config
hyprctl reload

echo "Restart complete!"
