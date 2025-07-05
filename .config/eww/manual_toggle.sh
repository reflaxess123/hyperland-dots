#!/bin/bash

cd ~/.config/eww

# Проверяем, открыт ли хотя бы один виджет
if eww active-windows | grep -q .; then
    # Есть открытые виджеты - закрываем все
    eww close-all
    echo "Widgets closed!"
else
    # Нет открытых виджетов - открываем все
    for widget in profile system clock uptime music weather apps folders github reddit twitter youtube mail logout sleep reboot poweroff; do
        eww open $widget
    done
    echo "Widgets opened!"
fi