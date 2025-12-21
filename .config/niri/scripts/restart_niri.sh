#!/bin/bash

# Restart script for Niri and related services
# Bind: Alt+Ctrl+W

echo "Restarting Niri services..."

# Kill and restart DMS (DankMaterialShell)
dms kill
sleep 1
dms run &

# Restart clipboard manager if running
if pgrep wl-paste > /dev/null; then
    pkill wl-paste
    sleep 1
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
fi

# Reload Niri config
niri msg action reload-config

echo "Restart complete!"
