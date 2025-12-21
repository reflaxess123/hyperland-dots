#!/bin/bash

# Monitor brightness control via ddcutil
# Requires: ddcutil, user in 'i2c' group

STEP=10

get_brightness() {
    ddcutil getvcp 10 2>/dev/null | grep -oP 'current value =\s*\K\d+'
}

set_brightness() {
    local value=$1
    # Clamp to 0-100
    (( value < 0 )) && value=0
    (( value > 100 )) && value=100
    ddcutil setvcp 10 "$value" 2>/dev/null
}

case "$1" in
    up)
        current=$(get_brightness)
        new=$((current + STEP))
        set_brightness $new
        ;;
    down)
        current=$(get_brightness)
        new=$((current - STEP))
        set_brightness $new
        ;;
esac

# Output for waybar
brightness=$(get_brightness)
if [[ -n "$brightness" ]]; then
    echo "{\"text\": \"󰃟 ${brightness}%\", \"tooltip\": \"Brightness: ${brightness}%\nScroll or click to adjust\"}"
else
    echo "{\"text\": \"󰃟 --\", \"tooltip\": \"Monitor not detected\"}"
fi
