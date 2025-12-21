#!/bin/bash

# GPU Fan Control Script with Dynamic Fan Curve
# Использует XWayland для управления вентиляторами в Hyprland

LOG_FILE="$HOME/.local/share/gpu-fan.log"
INTERVAL=5  # Интервал проверки температуры (секунды)

# Кривая вентилятора: температура -> скорость
TEMP_MIN=35   # При этой температуре и ниже - минимальная скорость
TEMP_MAX=85   # При этой температуре и выше - максимальная скорость
FAN_MIN=40    # Минимальная скорость вентилятора (%)
FAN_MAX=100   # Максимальная скорость вентилятора (%)

# Убедимся что DISPLAY установлен
export DISPLAY="${DISPLAY:-:0}"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

set_fan_speed() {
    local speed=$1
    DISPLAY=:0 xhost si:localuser:root > /dev/null 2>&1
    DISPLAY=:0 sudo /usr/bin/nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \
        -a "[fan:0]/GPUTargetFanSpeed=$speed" \
        -a "[fan:1]/GPUTargetFanSpeed=$speed" > /dev/null 2>&1
    local result=$?
    DISPLAY=:0 xhost -si:localuser:root > /dev/null 2>&1
    return $result
}

get_temp() {
    nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null
}

calculate_fan_speed() {
    local temp=$1

    if (( temp <= TEMP_MIN )); then
        echo $FAN_MIN
    elif (( temp >= TEMP_MAX )); then
        echo $FAN_MAX
    else
        # Квадратичная кривая (прогиб вниз - дольше тихо, резче к концу)
        local range_temp=$((TEMP_MAX - TEMP_MIN))
        local range_fan=$((FAN_MAX - FAN_MIN))
        local offset=$((temp - TEMP_MIN))
        # normalized^2 даёт выпуклую кривую
        local speed=$(awk "BEGIN {
            n = $offset / $range_temp;
            curved = n * n;
            printf \"%.0f\", $FAN_MIN + curved * $range_fan
        }")
        echo $speed
    fi
}

log "=== GPU Fan Control Started ==="
log "Fan curve: ${FAN_MIN}% at ${TEMP_MIN}°C -> ${FAN_MAX}% at ${TEMP_MAX}°C"

# Даем время XWayland запуститься
sleep 3

LAST_SPEED=0

while true; do
    TEMP=$(get_temp)

    if [[ -z "$TEMP" ]]; then
        log "ERROR: Cannot read GPU temperature"
        sleep $INTERVAL
        continue
    fi

    TARGET_SPEED=$(calculate_fan_speed $TEMP)

    # Меняем скорость только если отличается на 3% или больше
    DIFF=$((TARGET_SPEED - LAST_SPEED))
    DIFF=${DIFF#-}

    if (( DIFF >= 3 )) || (( LAST_SPEED == 0 )); then
        if set_fan_speed $TARGET_SPEED; then
            log "Temp: ${TEMP}°C -> Fan: ${TARGET_SPEED}%"
            LAST_SPEED=$TARGET_SPEED
        else
            log "ERROR: Failed to set fan speed"
        fi
    fi

    sleep $INTERVAL
done
