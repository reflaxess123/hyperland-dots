#!/bin/bash

# На всякий случай убиваем все зависшие экземпляры rofi (или других меню)
pkill -9 wofi      # если вдруг используешь

# Убиваем панели и сервисы
pkill waybar
pkill hyprpaper
pkill swaync
pkill swaykbdd

# Перезагружаем конфиг Hyprland
hyprctl reload
d
# Ждём немного (можно увеличить при необходимости)
sleep 1.2

# Запускаем сервисы обратно
waybar &
hyprpaper &
swaync &

# 🧠 Запускаем раскладку по окнам
/usr/bin/hyprland-per-window-layout &

# Уведомление о перезагрузке
notify-send -u low -i preferences-desktop-theme "Hyprland" "🌀 Конфиг и панели перезагружены" -t 2500