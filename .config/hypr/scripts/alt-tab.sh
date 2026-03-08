#!/bin/bash

# macOS-style Alt+Tab window switcher (per monitor, icons only)
# Uses rofi in horizontal mode with app icons

MONITOR=$(hyprctl activeworkspace -j | python3 -c "import json,sys; print(json.load(sys.stdin)['monitorID'])")

# Build rofi list: icon\tclass\taddress (filtered by current monitor, sorted by focus history)
WINDOWS=$(hyprctl clients -j | python3 -c "
import json, sys

clients = json.load(sys.stdin)
monitor = $MONITOR

# Filter by monitor, exclude special workspaces
filtered = [c for c in clients if c['monitor'] == monitor and c['workspace']['id'] > 0]

# Sort by focusHistoryID (lower = more recent)
filtered.sort(key=lambda c: c.get('focusHistoryID', 999))

seen = set()
for c in filtered:
    cls = c['class']
    if not cls or cls in seen:
        continue
    seen.add(cls)
    title = c['title'][:50] if c['title'] else cls
    addr = c['address']
    print(f'{title}\x00icon\x1f{cls}\x1finfo\x1f{addr}')
")

if [ -z "$WINDOWS" ]; then
    exit 0
fi

SELECTED=$(echo "$WINDOWS" | rofi -dmenu \
    -theme ~/.config/rofi/alt-tab.rasi \
    -selected-row 1 \
    -me-select-entry '' \
    -me-accept-entry MousePrimary)

if [ -n "$SELECTED" ]; then
    ADDR=$(echo "$SELECTED" | grep -oP 'info\x1f\K0x[0-9a-f]+' || true)
    if [ -z "$ADDR" ]; then
        # Fallback: find address by matching title
        ADDR=$(hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
title = '''$SELECTED'''.split('\x00')[0]
for c in clients:
    if c['title'][:50] == title:
        print(c['address'])
        break
")
    fi
    if [ -n "$ADDR" ]; then
        hyprctl dispatch focuswindow address:$ADDR
    fi
fi
