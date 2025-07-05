#!/bin/bash

VPN_NAME="anal-vpn"
VPN_CONF="/home/$USER/ANAL.ovpn"
PID_FILE="/tmp/$VPN_NAME.pid"

# Проверка по PID-файлу
if [ -f "$PID_FILE" ] && ps -p "$(cat $PID_FILE)" > /dev/null 2>&1; then
    echo "Stopping VPN..."
    sudo kill "$(cat $PID_FILE)"
    rm -f "$PID_FILE"
    notify-send "VPN отключён"
else
    echo "Starting VPN..."
    sudo openvpn --config "$VPN_CONF" --daemon
    # Ждём, пока PID появится
    sleep 1
    pid=$(pgrep -n openvpn)
    echo $pid > "$PID_FILE"
    notify-send "VPN включён"
fi
