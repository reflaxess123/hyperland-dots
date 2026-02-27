#!/bin/bash

# macOS-style Alt+Tab: instant cycle through windows on current monitor
# Each press switches to the next/previous window in focus history

REVERSE=0
[[ "$1" == "--reverse" ]] && REVERSE=1

MONITOR=$(hyprctl activeworkspace -j | python3 -c "import json,sys; print(json.load(sys.stdin)['monitorID'])")

NEXT=$(hyprctl clients -j | python3 -c "
import json, sys

clients = json.load(sys.stdin)
monitor = $MONITOR
reverse = $REVERSE

filtered = [c for c in clients if c['monitor'] == monitor and c['workspace']['id'] > 0 and not c.get('hidden', False)]
filtered.sort(key=lambda c: c.get('focusHistoryID', 999))

if len(filtered) > 1:
    if reverse:
        print(filtered[-1]['address'])
    else:
        print(filtered[1]['address'])
")

if [ -n "$NEXT" ]; then
    hyprctl dispatch focuswindow address:$NEXT
fi
