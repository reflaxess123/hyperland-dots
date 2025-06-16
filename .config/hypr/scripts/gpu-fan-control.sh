#!/bin/bash

# Включаем ручное управление вентиляторами
sudo nvidia-settings -a "[gpu:0]/GPUFanControlState=1" &>/dev/null

while true; do
    # Получаем текущую температуру GPU
    TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | head -n1)

    # Определяем скорость вентиляторов в зависимости от температуры
    if [ "$TEMP" -lt 46 ]; then
        SPEED=57
    elif [ "$TEMP" -lt 50 ]; then
        SPEED=65
    elif [ "$TEMP" -lt 62 ]; then
        SPEED=75
    elif [ "$TEMP" -lt 70 ]; then
        SPEED=80
    else
        SPEED=95
    fi

    # Применяем скорость к обоим вентиляторам
    sudo nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=$SPEED" &>/dev/null
    sudo nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=$SPEED" &>/dev/null

    # Пауза 5 секунд
    sleep 5
done

# xhost +SI:localuser:root
# sudo nvidia-settings -a "[gpu:0]/GPUFanControlState=1"
# sudo nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=80"
