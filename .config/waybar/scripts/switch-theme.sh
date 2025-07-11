#!/bin/bash

# Waybar theme switcher script
WAYBAR_CONFIG_DIR="/home/crock/.config/waybar"
SCRIPTS_DIR="$WAYBAR_CONFIG_DIR/scripts"
CURRENT_STYLE="$WAYBAR_CONFIG_DIR/style.css"
STATE_FILE="$SCRIPTS_DIR/.theme-state"

# Theme colors
declare -A DARK_THEME=(
    [bg]="rgba(26, 26, 26, 0)"
    [text]="#cad3f5"
    [module_bg]="#1d1d41"
    [module_border]="none"
    [workspace_text]="#cdd6f4"
    [workspace_active]="#89b4fa"
    [launcher]="#89b4fa"
    [power]="#f38ba8"
    [pulseaudio]="#89b4fa"
    [network]="#a6e3a1"
    [bluetooth]="#cba6f7"
    [cpu]="#fab387"
    [memory]="#f5c2e7"
    [disk]="#94e2d5"
    [clock]="#f9e2af"
    [language]="#a6e3a1"
    [vpn]="#cdd6f4"
    [vpn_connected]="#a6e3a1"
    [vpn_disconnected]="#f38ba8"
    [vpn_connecting]="#f9e2af"
    [temp]="#f38ba8"
    [fan]="#74c7ec"
    [slider_bg]="#302d41"
    [slider_fg]="#cad3f4"
    [tooltip_bg]="#10102e"
    [tooltip_text]="#cad3f5"
    [tooltip_border]="none"
)

declare -A WHITE_THEME=(
    [bg]="rgba(26, 26, 26, 0)"
    [text]="#2c2c2c"
    [module_bg]="#f0f0f0"
    [module_border]="1px solid #d0d0d0"
    [workspace_text]="#404040"
    [workspace_active]="#0066cc"
    [launcher]="#0066cc"
    [power]="#cc0000"
    [pulseaudio]="#0066cc"
    [network]="#009900"
    [bluetooth]="#6600cc"
    [cpu]="#cc6600"
    [memory]="#cc0066"
    [disk]="#00cc99"
    [clock]="#cc9900"
    [language]="#009900"
    [vpn]="#404040"
    [vpn_connected]="#009900"
    [vpn_disconnected]="#cc0000"
    [vpn_connecting]="#cc9900"
    [temp]="#cc0000"
    [fan]="#0099cc"
    [slider_bg]="#e0e0e0"
    [slider_fg]="#2c2c2c"
    [tooltip_bg]="#f8f8f8"
    [tooltip_text]="#2c2c2c"
    [tooltip_border]="1px solid #d0d0d0"
)

# Function to generate CSS
generate_css() {
    local -n colors=$1
    cat > "$CURRENT_STYLE" << EOF
* {
  border: none;
  border-radius: 0;
  font-family: "Roboto", sans-serif;
  font-size: 16px;
  min-height: 0;
  font-weight: bold;
}

window#waybar {
  background: ${colors[bg]};
  color: ${colors[text]};
}

/* Левый блок */
.modules-left {
  background-color: ${colors[module_bg]};
  border-radius: 25px;
  padding: 0 15px;
  border: none;
}

/* Правый блок */
.modules-right {
  background-color: ${colors[module_bg]};
  border-radius: 25px;
  padding: 0 15px;
  border: none;
}

.modules-center {
  background-color: ${colors[module_bg]};
  border-radius: 25px;
  padding: 0 5px;
  border: none;
}

/* Reset all modules */
#workspaces,
#clock,
#pulseaudio,
#custom-mic-volume,
#pulseaudio-slider,
#network,
#bluetooth,
#cpu,
#custom-cpu-temp,
#custom-gpu-temp,
#custom-fan,
#memory,
#disk,
#tray,
#hyprland-language,
#custom-power,
#custom-launcher,
#language {
  padding: 10px 10px;
  margin: 0 2px;
  color: ${colors[text]};
}

#workspaces {
  margin: 5px;
  padding: 0 5px;
  border-radius: 6px;
}

#workspaces button {
  padding: 0 5px;
  color: ${colors[workspace_text]};
  transition: all 0.3s ease;
}

#workspaces button:hover {
  background: rgba(100, 100, 100, 0);
}

#workspaces button.active {
  color: ${colors[workspace_active]};
}

#custom-launcher {
  color: ${colors[launcher]};
  font-size: 16px;
  padding: 0 15px;
}

#custom-power {
  color: ${colors[power]};
  font-size: 16px;
  padding: 0 15px;
}

/* Style for specific icons/modules that need it */
#pulseaudio {
  color: ${colors[pulseaudio]};
}

#network {
  color: ${colors[network]};
}

#bluetooth {
  color: ${colors[bluetooth]};
}

#cpu {
  color: ${colors[cpu]};
}

#memory {
  color: ${colors[memory]};
}

#disk {
  color: ${colors[disk]};
}

#clock {
  color: ${colors[clock]};
  font-weight: bold;
}

/* Hide sliders by default */
#pulseaudio-slider slider {
  min-height: 0px;
  min-width: 0px;
  opacity: 0;
  background: none;
  border: none;
  box-shadow: none;
  margin: 0;
  padding: 0;
}

#pulseaudio-slider trough {
  min-height: 12px;
  min-width: 80px;
  border-radius: 5px;
  background-color: ${colors[slider_bg]};
}

#pulseaudio-slider highlight {
  min-width: 12px;
  min-height: 12px;
  border-radius: 9999px;
  background-color: ${colors[slider_fg]};
}

/* VPN индикатор */
#custom-vpn {
  color: ${colors[vpn]};
  padding: 0 10px;
  font-weight: bold;
}

#custom-vpn.connected {
  color: ${colors[vpn_connected]};
}

#custom-vpn.disconnected {
  color: ${colors[vpn_disconnected]};
}

#custom-vpn.connecting {
  color: ${colors[vpn_connecting]};
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    opacity: 1;
  }

  50% {
    opacity: 0.6;
  }

  100% {
    opacity: 1;
  }
}

#custom-cpu-temp,
#custom-gpu-temp {
  color: ${colors[temp]};
}

#custom-fan {
  color: ${colors[fan]};
}

#tray {
  margin: 0 5px;
}

/* Языковой индикатор */
#language {
  padding: 0 10px;
  margin: 0 2px;
  border-radius: 6px;
  color: ${colors[language]};
  font-weight: bold;
}

/* Слайдер громкости */
#pulseaudio.slider {
  min-width: 100px;
}

tooltip {
  border-radius: 15px;
  background-color: ${colors[tooltip_bg]};
  color: ${colors[tooltip_text]};
  border: ${colors[tooltip_border]};
}
EOF
}

# Create scripts directory if it doesn't exist
mkdir -p "$SCRIPTS_DIR"

# Read current theme state
if [ -f "$STATE_FILE" ]; then
    CURRENT_THEME=$(cat "$STATE_FILE")
else
    CURRENT_THEME="white"  # Default to white
fi

# Toggle between themes
if [ "$CURRENT_THEME" = "dark" ]; then
    # Switch to white
    generate_css WHITE_THEME
    echo "white" > "$STATE_FILE"
    # Set GTK theme to light
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    
    # Switch NeoVim to light theme
    sed -i 's/theme = "onedark"/theme = "github_light"/' /home/crock/.config/nvim/lua/chadrc.lua
    
    # Switch Ghostty to light theme
    sed -i 's/foreground = ffffff/foreground = 2c2c2c/' /home/crock/.config/ghostty/config
    sed -i 's/background = 0d1117/background = ffffff/' /home/crock/.config/ghostty/config
    sed -i 's/cursor-color = ff79c6/cursor-color = 0066cc/' /home/crock/.config/ghostty/config
    
    # Update palette for light theme - darker colors for better contrast
    sed -i 's/palette = 0=44475a/palette = 0=000000/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 1=ff5555/palette = 1=cc0000/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 2=50fa7b/palette = 2=006600/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 3=ffb86c/palette = 3=994400/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 4=8be9fd/palette = 4=0066cc/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 5=bd93f9/palette = 5=6600cc/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 6=ff79c6/palette = 6=006666/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 7=f8f8f2/palette = 7=999999/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 8=6272a4/palette = 8=333333/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 9=ff6e6e/palette = 9=ff0000/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 10=69ff94/palette = 10=008800/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 11=ffffa5/palette = 11=aa6600/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 12=d6acff/palette = 12=0088ff/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 13=ff92df/palette = 13=8800ff/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 14=a4ffff/palette = 14=008888/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 15=ffffff/palette = 15=333333/' /home/crock/.config/ghostty/config
    
    # Switch tmux to light theme
    sed -i 's/tmux_conf_theme_colour_1="#080808"/tmux_conf_theme_colour_1="#f8f8f8"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_2="#303030"/tmux_conf_theme_colour_2="#e0e0e0"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_3="#8a8a8a"/tmux_conf_theme_colour_3="#666666"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_4="#00afff"/tmux_conf_theme_colour_4="#0066cc"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_5="#ffff00"/tmux_conf_theme_colour_5="#cc6600"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_6="#080808"/tmux_conf_theme_colour_6="#f8f8f8"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_7="#e4e4e4"/tmux_conf_theme_colour_7="#333333"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_8="#080808"/tmux_conf_theme_colour_8="#f8f8f8"/' /home/crock/.tmux/.tmux.conf.local
    
    echo "Switched to white theme"
else
    # Switch to dark
    generate_css DARK_THEME
    echo "dark" > "$STATE_FILE"
    # Set GTK theme to dark
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    # Switch NeoVim to dark theme
    sed -i 's/theme = "github_light"/theme = "onedark"/' /home/crock/.config/nvim/lua/chadrc.lua
    
    # Switch Ghostty to dark theme
    sed -i 's/foreground = 2c2c2c/foreground = ffffff/' /home/crock/.config/ghostty/config
    sed -i 's/background = ffffff/background = 0d1117/' /home/crock/.config/ghostty/config
    sed -i 's/cursor-color = 0066cc/cursor-color = ff79c6/' /home/crock/.config/ghostty/config
    
    # Update palette for dark theme - bright colors for dark background
    sed -i 's/palette = 0=000000/palette = 0=44475a/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 1=cc0000/palette = 1=ff5555/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 2=006600/palette = 2=50fa7b/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 3=994400/palette = 3=ffb86c/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 4=0066cc/palette = 4=8be9fd/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 5=6600cc/palette = 5=bd93f9/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 6=006666/palette = 6=ff79c6/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 7=999999/palette = 7=f8f8f2/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 8=333333/palette = 8=6272a4/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 9=ff0000/palette = 9=ff6e6e/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 10=008800/palette = 10=69ff94/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 11=aa6600/palette = 11=ffffa5/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 12=0088ff/palette = 12=d6acff/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 13=8800ff/palette = 13=ff92df/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 14=008888/palette = 14=a4ffff/' /home/crock/.config/ghostty/config
    sed -i 's/palette = 15=333333/palette = 15=ffffff/' /home/crock/.config/ghostty/config
    
    # Switch tmux to dark theme
    sed -i 's/tmux_conf_theme_colour_1="#f8f8f8"/tmux_conf_theme_colour_1="#080808"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_2="#e0e0e0"/tmux_conf_theme_colour_2="#303030"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_3="#666666"/tmux_conf_theme_colour_3="#8a8a8a"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_4="#0066cc"/tmux_conf_theme_colour_4="#00afff"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_5="#cc6600"/tmux_conf_theme_colour_5="#ffff00"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_6="#f8f8f8"/tmux_conf_theme_colour_6="#080808"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_7="#333333"/tmux_conf_theme_colour_7="#e4e4e4"/' /home/crock/.tmux/.tmux.conf.local
    sed -i 's/tmux_conf_theme_colour_8="#f8f8f8"/tmux_conf_theme_colour_8="#080808"/' /home/crock/.tmux/.tmux.conf.local
    
    echo "Switched to dark theme"
fi

# Restart waybar to apply changes with delay
pkill waybar
waybar &

# Reload tmux config if tmux is running
if pgrep tmux > /dev/null; then
    tmux source-file ~/.tmux.conf 2>/dev/null || true
fi