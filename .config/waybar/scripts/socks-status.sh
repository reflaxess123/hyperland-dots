#!/bin/bash

STATE_FILE="/tmp/redsocks_toggle_state"

if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "1" ]]; then
    echo '{"text": "󰖂 On", "class": "connected", "tooltip": "redsocks активен"}'
else
    echo '{"text": "󰖂 Off", "class": "disconnected", "tooltip": "redsocks выключен"}'
fi 