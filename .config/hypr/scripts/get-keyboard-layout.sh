#!/bin/bash
# Universal keyboard layout detector for Hyprland and Niri

if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ] || pgrep -x Hyprland > /dev/null; then
    # Hyprland
    hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -c 2 | tr '[:lower:]' '[:upper:]'
elif [ "$XDG_CURRENT_DESKTOP" = "niri" ] || pgrep -x niri > /dev/null; then
    # Niri
    niri msg keyboard-layouts 2>/dev/null | grep '^\s*\*' | sed 's/.*\* [0-9]* //' | head -c 2 | tr '[:lower:]' '[:upper:]'
else
    echo "??"
fi
