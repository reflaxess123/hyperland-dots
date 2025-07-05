#!/bin/bash

declare -A options
options["⇠"]="hyprctl dispatch exit"
options["⏾"]="systemctl suspend"
options["⏻"]="systemctl poweroff"
options["⏼"]="systemctl reboot"

entries=$(printf "%s\n" "${!options[@]}")

selected=$(echo -e "$entries" | wofi --dmenu --prompt "Power Menu" --cache-file /dev/null)

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