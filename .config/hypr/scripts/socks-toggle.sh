#!/bin/bash

# Файл для хранения состояния
STATE_FILE="/tmp/redsocks_toggle_state"

start_redsocks() {
    sudo iptables -t nat -F
    sudo pkill redsocks
    sudo redsocks -c /etc/redsocks.conf &
    sleep 1
    sudo iptables -t nat -N REDSOCKS 2>/dev/null
    sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
    sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
    sudo iptables -t nat -A OUTPUT -p tcp -m owner ! --uid-owner 0 -j REDSOCKS
    echo 1 > "$STATE_FILE"
    # notify-send "🧦 Прокси включен"
}

stop_redsocks() {
    sudo iptables -t nat -F
    sudo pkill redsocks
    echo 0 > "$STATE_FILE"
    # notify-send "🧦 Прокси отключен"
}

# Проверяем состояние
if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "1" ]]; then
    stop_redsocks
else
    start_redsocks
fi

# Обновляем waybar
pkill -SIGRTMIN+8 waybar 2>/dev/null || true 
