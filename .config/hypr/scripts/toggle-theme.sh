#!/bin/bash

# Toggle dark/light theme system-wide
# Bind: CTRL + Y

STATE_FILE="$HOME/.config/hypr/.theme-state"
WAYBAR_DIR="$HOME/.config/waybar"

current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [ "$current" = "dark" ]; then
    # Switch to light
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    ln -sf "$WAYBAR_DIR/style-light.css" "$WAYBAR_DIR/style.css"
    echo "light" > "$STATE_FILE"
else
    # Switch to dark
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark'
    ln -sf "$WAYBAR_DIR/style-dark.css" "$WAYBAR_DIR/style.css"
    echo "dark" > "$STATE_FILE"
fi

# Restart waybar to apply CSS
pkill waybar 2>/dev/null
sleep 0.3
waybar &disown
