#!/bin/bash

# Получаем путь к выделенному файлу из буфера (предварительно копируй файл в Thunar)
FILE=$(xclip -o -selection clipboard)

if [[ ! -f "$FILE" ]]; then
    notify-send "Файл не найден" "Сначала скопируй файл в Thunar (Ctrl+C)"
    exit 1
fi

MIME=$(file --mime-type -b "$FILE")

case "$MIME" in
  image/*)
    imv "$FILE" &
    ;;
  video/*)
    mpv --no-terminal "$FILE" &
    ;;
  application/pdf)
    zathura "$FILE" &
    ;;
  text/*)
    kitty sh -c "bat --paging=always \"$FILE\"" &
    ;;
  *)
    notify-send "Нет предпросмотра для" "$MIME"
    ;;
esac
