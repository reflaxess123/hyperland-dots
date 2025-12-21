#!/bin/bash

STATE_FILE="/tmp/redsocks_toggle_state"

if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "1" ]]; then
    echo '{"text": "Socks On", "class": "connected", "tooltip": "redsocks активен"}'
else
    echo '{"text": "Socks Off", "class": "disconnected", "tooltip": "redsocks выключен"}'
fi 