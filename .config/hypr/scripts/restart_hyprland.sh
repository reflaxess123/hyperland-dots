#!/bin/bash

# Restart script for Hyprland and related services
# Bind: $mainMod CTRL + W

# Find current Hyprland socket
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr/ 2>/dev/null | head -1)

echo "Restarting Hyprland services..."

# Detect shell from config (not running process)
if grep -q "^exec-once = dms" ~/.config/hypr/hyprland.conf; then
    SHELL_TYPE="dms"
elif grep -q "^exec-once = caelestia" ~/.config/hypr/hyprland.conf; then
    SHELL_TYPE="caelestia"
else
    SHELL_TYPE="none"
fi

# Kill any running shells
pkill -x qs 2>/dev/null
pkill -x dms 2>/dev/null
dms kill 2>/dev/null
sleep 1

# Start the configured shell
case $SHELL_TYPE in
    dms)
        echo "Starting DMS..."
        dms run &
        ;;
    caelestia)
        echo "Starting Caelestia Shell..."
        caelestia shell -d &
        ;;
    *)
        echo "No shell configured"
        ;;
esac

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
