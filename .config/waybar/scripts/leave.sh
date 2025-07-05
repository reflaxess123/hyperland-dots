#!/bin/bash

declare -A options
options["⇠ Выход"]="hyprctl dispatch exit"
options["⏾ Спящий режим"]="systemctl suspend"
options["⏻ Выключить"]="systemctl poweroff"
options["⏼ Перезагрузить"]="systemctl reboot"

entries=$(printf "%s\n" "${!options[@]}")

selected=$(echo -e "$entries" | wofi --dmenu --prompt "Power Menu" --cache-file /dev/null --height=530 --width=500 --style=/home/crock/.config/waybar/scripts/leave-style.css -D hide_search=true)

if [ -n "$selected" ]; then
    command="${options[$selected]}"
    if [ -n "$command" ]; then
        if [[ $command == systemctl* ]]; then
            exec $command
        else
            $command
        fi
    fi
fi 