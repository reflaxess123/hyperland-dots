#!/bin/bash

# Power menu with rofi (Catppuccin style)

ROFI_THEME="$HOME/.config/rofi/powermenu.rasi"

options="󰐥\n󰜉\n󰤄\n󰍃"

selected=$(echo -e "$options" | rofi -dmenu \
    -p "" \
    -mesg "Power Menu" \
    -theme "$ROFI_THEME")

case "$selected" in
    "󰐥") systemctl poweroff ;;
    "󰜉") systemctl reboot ;;
    "󰤄") systemctl suspend ;;
    "󰍃") hyprctl dispatch exit ;;
esac
