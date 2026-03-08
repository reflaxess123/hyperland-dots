#!/bin/bash
# Переключение воркспейсов
# Usage: workspace-switch.sh <number> [move]

TARGET=$1
ACTION=$2

if [[ "$ACTION" == "move" ]]; then
    hyprctl dispatch movetoworkspace "$TARGET"
else
    hyprctl dispatch workspace "$TARGET"
fi
