#!/bin/bash

# Toggle dark/light theme system-wide
# Bind: CTRL + Y
# Affects: GTK apps, Telegram, Zen, waybar, Ghostty, nvim, VSCode

STATE_FILE="$HOME/.config/hypr/.theme-state"
WAYBAR_DIR="$HOME/.config/waybar"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
GHOSTTY_THEMES="$HOME/.config/ghostty/themes"

current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [ "$current" = "dark" ]; then
    MODE="light"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    ln -sf "$WAYBAR_DIR/style-light.css" "$WAYBAR_DIR/style.css"
else
    MODE="dark"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark'
    ln -sf "$WAYBAR_DIR/style-dark.css" "$WAYBAR_DIR/style.css"
fi

# Ghostty: swap theme block in config (write to tmp, then move atomically)
TMPCONF=$(mktemp)
sed '/^foreground = /d;/^background = /d;/^background-opacity = /d;/^window-theme = /d;/^selection-foreground = /d;/^selection-background = /d;/^cursor-color = /d;/^palette = /d' "$GHOSTTY_CONFIG" > "$TMPCONF"
cat "$GHOSTTY_THEMES/$MODE.conf" >> "$TMPCONF"
mv "$TMPCONF" "$GHOSTTY_CONFIG"

# Hyprland: border colors
if [ "$MODE" = "light" ]; then
    hyprctl keyword general:col.active_border "rgba(ffffffcc)" 2>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(d5c4a144)" 2>/dev/null
else
    hyprctl keyword general:col.active_border "rgba(ffffffcc)" 2>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(28282800)" 2>/dev/null
fi

# Nvim: notify all running instances
for sock in /run/user/1000/nvim.*.0 /tmp/nvim.*/0; do
    nvim --server "$sock" --remote-send ":set background=$MODE<CR>" 2>/dev/null
done

# VSCode: switch colorTheme
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
if [ -f "$VSCODE_SETTINGS" ]; then
    if [ "$MODE" = "light" ]; then
        sed -i 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Bearded Theme Milkshake Mint"/' "$VSCODE_SETTINGS"
    else
        sed -i 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Gruvbox Dark Hard"/' "$VSCODE_SETTINGS"
    fi
fi

echo "$MODE" > "$STATE_FILE"

# Restart waybar
pkill waybar 2>/dev/null
sleep 0.3
waybar &disown
