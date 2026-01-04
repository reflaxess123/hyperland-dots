#!/bin/bash

# Restart script for Hyprland and related services
# Bind: $mainMod CTRL + W

# Find current Hyprland socket
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr/ 2>/dev/null | head -1)

echo "Restarting Hyprland services..."

# Detect and restart current shell
if pgrep -x qs > /dev/null; then
    # Caelestia Shell (runs as 'qs')
    echo "Restarting Caelestia Shell..."
    pkill -x qs
    sleep 1
    caelestia shell -d &
elif pgrep -x dms > /dev/null; then
    # DankMaterialShell
    echo "Restarting DMS..."
    dms kill
    sleep 1
    dms run &
else
    # Try to detect from config
    if grep -q "^exec-once = caelestia" ~/.config/hypr/hyprland.conf; then
        caelestia shell -d &
    elif grep -q "^exec-once = dms" ~/.config/hypr/hyprland.conf; then
        dms run &
    fi
fi

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
