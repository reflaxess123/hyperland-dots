#!/bin/bash
# Universal keyboard layout switcher for Hyprland and Niri

if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ] || pgrep -x Hyprland > /dev/null; then
    # Hyprland
    hyprctl switchxkblayout all next
elif [ "$XDG_CURRENT_DESKTOP" = "niri" ] || pgrep -x niri > /dev/null; then
    # Niri
    niri msg action switch-layout next
fi
