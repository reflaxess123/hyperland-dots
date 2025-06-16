#!/bin/bash

WALLDIR="$HOME/wallpapers"
CONF="$HOME/.config/hypr/hyprpaper.conf"

# Получаем текущую обойну
CURRENT=$(grep '^wallpaper' "$CONF" | cut -d',' -f2)

# Получаем список всех .jpg и .png файлов, отсортированных
readarray -t FILES < <(find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)

# Если список пуст — выходим
if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "❌ Нет файлов в $WALLDIR"
  exit 1
fi

# Если текущая обоина не найдена — начать с первой
NEXT="${FILES[0]}"
for i in "${!FILES[@]}"; do
    if [[ "${FILES[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#FILES[@]} ))
        NEXT="${FILES[$NEXT_INDEX]}"
        break
    fi
done

# Перезаписываем конфиг
echo "preload = $NEXT" > "$CONF"
echo "wallpaper = ,$NEXT" >> "$CONF"

# Перезапускаем hyprpaper
pkill hyprpaper
hyprpaper -c "$CONF" &
