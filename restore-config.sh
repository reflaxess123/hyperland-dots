#!/bin/bash

# Скрипт для полного восстановления системы
# Устанавливает весь необходимый софт и конфиги

set -e

echo "=========================================="
echo "  Hyprland Dotfiles Restore Script"
echo "=========================================="

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Проверка root
if [[ $EUID -eq 0 ]]; then
    log_error "Не запускай от root! Используй обычного пользователя."
    exit 1
fi

# ==========================================
# 1. Установка yay (AUR helper)
# ==========================================
install_yay() {
    log_info "Установка yay..."
    if command -v yay &> /dev/null; then
        log_info "yay уже установлен"
        return
    fi

    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    log_info "yay установлен"
}

# ==========================================
# 2. Установка пакетов из pacman
# ==========================================
install_pacman_packages() {
    log_info "Установка pacman пакетов..."

    local packages=(
        # Базовые
        git
        base-devel

        # Shell
        zsh
        zsh-autosuggestions
        zsh-syntax-highlighting

        # Терминальные утилиты
        neovim
        tmux
        bat
        eza
        fd
        fzf
        ripgrep
        yazi
        lazygit
        htop
        curl
        wget
        unzip

        # Wayland/Hyprland
        hyprland
        waybar
        wofi
        swaync
        swww
        hyprshot
        wl-clipboard
        cliphist
        udiskie
        network-manager-applet
        pavucontrol
        nautilus

        # Dev tools
        npm
        python
        python-pip
        python-poetry
        docker
        docker-compose

        # Misc
        ghostty
        kitty
        alacritty
        neofetch

        # NVIDIA GPU Fan Control
        nvidia-settings
        xorg-server
        xorg-xhost
    )

    sudo pacman -S --needed --noconfirm "${packages[@]}" || log_warn "Некоторые пакеты не найдены в pacman"
    log_info "pacman пакеты установлены"
}

# ==========================================
# 3. Установка AUR пакетов
# ==========================================
install_aur_packages() {
    log_info "Установка AUR пакетов..."

    local aur_packages=(
        google-chrome
        brave-bin
        telegram-desktop
        redsocks
        mission-center
    )

    for pkg in "${aur_packages[@]}"; do
        if ! yay -Qi "$pkg" &> /dev/null; then
            log_info "Установка $pkg..."
            yay -S --noconfirm "$pkg" || log_warn "Не удалось установить $pkg"
        else
            log_info "$pkg уже установлен"
        fi
    done

    log_info "AUR пакеты установлены"
}

# ==========================================
# 4. Установка шрифтов
# ==========================================
install_fonts() {
    log_info "Установка шрифтов..."

    # Maple Mono NF CN
    if ! fc-list | grep -qi "maple"; then
        log_info "Установка Maple Mono NF CN..."
        yay -S --noconfirm ttf-maple || {
            log_warn "ttf-maple не найден в AUR, скачиваю вручную..."
            mkdir -p ~/.local/share/fonts
            cd /tmp
            curl -LO https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-CN.zip
            unzip -o MapleMono-NF-CN.zip -d ~/.local/share/fonts/
            fc-cache -fv
        }
    else
        log_info "Maple Mono уже установлен"
    fi

    # Playpen Sans
    if ! fc-list | grep -qi "playpen"; then
        log_info "Установка Playpen Sans..."
        mkdir -p ~/.local/share/fonts
        cd /tmp
        curl -LO "https://github.com/nickshanks/Playpen-Sans/releases/latest/download/PlaypenSans.zip" 2>/dev/null || \
        curl -LO "https://fonts.google.com/download?family=Playpen%20Sans" -o PlaypenSans.zip 2>/dev/null || {
            log_warn "Скачиваю Playpen Sans с Google Fonts..."
            curl -L "https://fonts.google.com/download?family=Playpen%20Sans" -o PlaypenSans.zip
        }
        unzip -o PlaypenSans.zip -d ~/.local/share/fonts/ 2>/dev/null || true
        fc-cache -fv
    else
        log_info "Playpen Sans уже установлен"
    fi

    # Nerd Fonts (дополнительно)
    sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd ttf-firacode-nerd 2>/dev/null || true

    log_info "Шрифты установлены"
}

# ==========================================
# 5. Настройка redsocks
# ==========================================
setup_redsocks() {
    log_info "Настройка redsocks..."

    # Конфиг redsocks
    sudo tee /etc/redsocks.conf > /dev/null << 'EOF'
base {
    log_debug = off;
    log_info = on;
    log = "syslog:daemon";
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 127.0.0.1;
    local_port = 12345;

    ip = 78.40.193.120;
    port = 46764;
    type = socks5;
}
EOF

    # Sudoers для скрипта socks-toggle.sh (iptables, redsocks, pkill)
    sudo tee /etc/sudoers.d/redsocks > /dev/null << EOF
$USER ALL=(ALL) NOPASSWD: /usr/bin/iptables
$USER ALL=(ALL) NOPASSWD: /usr/bin/redsocks
$USER ALL=(ALL) NOPASSWD: /usr/bin/pkill redsocks
EOF
    sudo chmod 440 /etc/sudoers.d/redsocks

    log_info "redsocks настроен (используй Alt+I для toggle)"
}

# ==========================================
# 6. Настройка NVIDIA GPU Fan Control
# ==========================================
setup_gpu_fan() {
    log_info "Настройка GPU Fan Control..."

    # Проверка nvidia
    if ! lspci | grep -qi nvidia; then
        log_warn "NVIDIA GPU не найден, пропускаем настройку вентиляторов"
        return
    fi

    # Получаем BusID видеокарты
    local BUS_ID=$(lspci | grep -i 'vga.*nvidia' | awk '{print $1}' | head -1)
    if [[ -z "$BUS_ID" ]]; then
        BUS_ID=$(lspci | grep -i nvidia | awk '{print $1}' | head -1)
    fi

    # Конвертируем BusID в формат для xorg (09:00.0 -> PCI:9:0:0)
    local BUS_ID_XORG=$(echo "$BUS_ID" | awk -F'[:.]' '{printf "PCI:%d:%d:%d", "0x"$1, "0x"$2, $3}')
    log_info "NVIDIA GPU: $BUS_ID -> $BUS_ID_XORG"

    # Создаём xorg.conf с Coolbits
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo tee /etc/X11/xorg.conf.d/20-nvidia.conf > /dev/null << EOF
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "$BUS_ID_XORG"
    Option         "Coolbits" "4"
    Option         "AllowEmptyInitialConfiguration" "True"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
EndSection
EOF

    # Создаём скрипт настройки вентиляторов
    sudo tee /usr/local/bin/gpu-fan-setup.sh > /dev/null << 'SCRIPT'
#!/bin/bash
LOG="/var/log/gpu-fan.log"
FAN_SPEED="${GPU_FAN_SPEED:-62}"

echo "[$(date)] Starting GPU fan setup (target: ${FAN_SPEED}%)..." >> $LOG

X :99 -config /etc/X11/xorg.conf.d/20-nvidia.conf -sharevts -noreset &
XPID=$!
sleep 3

if kill -0 $XPID 2>/dev/null; then
    echo "[$(date)] X server started on :99" >> $LOG
    DISPLAY=:99 nvidia-settings -a "[gpu:0]/GPUFanControlState=1" >> $LOG 2>&1
    DISPLAY=:99 nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=$FAN_SPEED" >> $LOG 2>&1
    DISPLAY=:99 nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=$FAN_SPEED" >> $LOG 2>&1
    SPEED=$(DISPLAY=:99 nvidia-settings -q "[fan:0]/GPUTargetFanSpeed" -t 2>/dev/null)
    echo "[$(date)] Fan speed set to: ${SPEED}%" >> $LOG
    kill $XPID 2>/dev/null
    echo "[$(date)] X server stopped, fan settings preserved" >> $LOG
else
    echo "[$(date)] ERROR: Failed to start X server" >> $LOG
    exit 1
fi
SCRIPT

    sudo chmod +x /usr/local/bin/gpu-fan-setup.sh

    # Создаём systemd сервис
    sudo tee /etc/systemd/system/gpu-fan.service > /dev/null << 'SERVICE'
[Unit]
Description=NVIDIA GPU Fan Control
Before=display-manager.service
After=nvidia-persistenced.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/gpu-fan-setup.sh
RemainAfterExit=yes
Environment="GPU_FAN_SPEED=62"

[Install]
WantedBy=multi-user.target
SERVICE

    sudo systemctl daemon-reload
    sudo systemctl enable gpu-fan.service

    # Добавляем sudoers правило для nvidia-settings (для динамического контроля через XWayland)
    echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/nvidia-settings" | sudo tee /etc/sudoers.d/nvidia-settings > /dev/null
    sudo chmod 440 /etc/sudoers.d/nvidia-settings

    log_info "GPU Fan Control настроен"
    log_info "  - Systemd сервис: 62% при загрузке (до запуска Hyprland)"
    log_info "  - Демон: динамическая кривая после запуска Hyprland"
}

# ==========================================
# 7. Установка Oh-My-Zsh и Powerlevel10k
# ==========================================
install_ohmyzsh() {
    log_info "Установка Oh-My-Zsh..."

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        log_info "Oh-My-Zsh уже установлен"
    fi

    # Powerlevel10k
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        log_info "Установка Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    else
        log_info "Powerlevel10k уже установлен"
    fi

    log_info "Oh-My-Zsh настроен"
}

# ==========================================
# 7. Установка TPM (Tmux Plugin Manager)
# ==========================================
install_tpm() {
    log_info "Установка TPM..."

    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        log_info "TPM уже установлен"
    fi

    # Установка плагинов
    ~/.tmux/plugins/tpm/bin/install_plugins 2>/dev/null || true

    log_info "TPM настроен"
}

# ==========================================
# 8. Установка NvChad
# ==========================================
install_nvchad() {
    log_info "Установка NvChad..."

    # Бэкап старого конфига
    if [[ -d "$HOME/.config/nvim" ]]; then
        log_info "Бэкап старого nvim конфига..."
        rm -rf "$HOME/.config/nvim.bak"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi

    # Удаляем кэш
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim

    # Клонируем кастомный NvChad конфиг
    log_info "Клонирование кастомного NvChad конфига..."
    git clone https://github.com/reflaxess123/nvchad3 ~/.config/nvim

    log_info "NvChad установлен. Запусти nvim для завершения установки плагинов."
}

# ==========================================
# 9. Копирование конфигов
# ==========================================
copy_configs() {
    log_info "Копирование конфигов..."

    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    local items=(
        ".zshrc"
        ".tmux.conf"
        ".p10k.zsh"
        ".config/hypr"
        ".config/waybar"
        ".config/ghostty"
        ".config/kitty"
        ".config/alacritty"
        ".config/wofi"
        ".config/swaync"
        ".config/swaykbdd"
        ".config/neofetch"
        ".config/scripts"
        ".config/Cursor"
    )

    for item in "${items[@]}"; do
        local src="$SCRIPT_DIR/$item"
        local dest="$HOME/$item"

        if [[ -e "$src" ]]; then
            local parent_dir=$(dirname "$dest")
            mkdir -p "$parent_dir"
            rm -rf "$dest"
            cp -r "$src" "$dest"
            log_info "Скопировано: $item"
        fi
    done

    log_info "Конфиги скопированы"
}

# ==========================================
# 10. Делаем скрипты исполняемыми
# ==========================================
make_scripts_executable() {
    log_info "Делаем скрипты исполняемыми..."

    chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/scripts/*.sh 2>/dev/null || true

    log_info "Скрипты готовы"
}

# ==========================================
# 11. Установка zsh по умолчанию
# ==========================================
set_default_shell() {
    log_info "Установка zsh как shell по умолчанию..."

    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s $(which zsh)
        log_info "zsh установлен по умолчанию. Перелогинься для применения."
    else
        log_info "zsh уже установлен по умолчанию"
    fi
}

# ==========================================
# MAIN
# ==========================================
main() {
    install_yay
    install_pacman_packages
    install_aur_packages
    install_fonts
    setup_redsocks
    setup_gpu_fan
    install_ohmyzsh
    install_tpm
    copy_configs
    make_scripts_executable
    install_nvchad
    set_default_shell

    echo ""
    echo "=========================================="
    echo -e "${GREEN}  Установка завершена!${NC}"
    echo "=========================================="
    echo ""
    echo "Следующие шаги:"
    echo "  1. ПЕРЕЗАГРУЗИСЬ для применения GPU fan control и zsh"
    echo "  2. Запусти nvim для установки плагинов"
    echo "  3. В tmux нажми Ctrl+a затем I для установки плагинов"
    echo "  4. VPN toggle: Alt+I"
    echo "  5. Проверь вентиляторы: nvidia-smi --query-gpu=fan.speed --format=csv"
    echo ""
}

main "$@"
