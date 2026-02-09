#!/bin/bash
# Переключение воркспейсов с учётом монитора
# DP-1 (левый): workspaces 1-10
# DP-2 (правый): workspaces 11-20
# Usage: workspace-switch.sh <number> [move]

NUM=$1
ACTION=$2

FOCUSED_MON=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

OFFSET=0
if [[ "$FOCUSED_MON" == "DP-2" ]]; then
    OFFSET=10
fi

TARGET=$((NUM + OFFSET))

if [[ "$ACTION" == "move" ]]; then
    hyprctl dispatch movetoworkspace "$TARGET"
else
    hyprctl dispatch workspace "$TARGET"
fi
