#!/bin/bash

# Завершаем waybar
pkill waybar

# Ждем немного
sleep 1

# Запускаем waybar заново
waybar &

# Отправляем уведомление
notify-send "🔄 Waybar" "Waybar перезапущен" -t 2000 