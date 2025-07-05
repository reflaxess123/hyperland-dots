#!/bin/bash

PIDFILE="/tmp/wf-recorder.pid"
OUTPUT="$HOME/Videos/recording-$(date +%F_%H-%M-%S).mp4"

if [ -f "$PIDFILE" ]; then
    # Если запись уже идёт — остановить
    kill "$(cat "$PIDFILE")"
    rm "$PIDFILE"
    notify-send "wf-recorder" "Запись остановлена"
else
    # Иначе — начать запись
    wf-recorder -f "$OUTPUT" &
    echo $! > "$PIDFILE"
    notify-send "wf-recorder" "Запись начата: $OUTPUT"
fi 