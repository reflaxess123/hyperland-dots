#!/bin/bash

STATE_FILE="/tmp/redsocks_toggle_state"

if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "1" ]]; then
    echo '{"text": "🧦 SOCKS5 ON", "tooltip": "redsocks активен"}'
else
    echo '{"text": "🧦 SOCKS5 OFF", "tooltip": "redsocks выключен"}'
fi 