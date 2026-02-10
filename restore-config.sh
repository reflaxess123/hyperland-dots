#!/bin/bash

# Скрипт для полного восстановления системы
# Устанавливает весь необходимый софт и конфиги

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
        hyprpaper
        waybar
        rofi-wayland
        wofi
        swaync
        swww
        hyprshot
        wl-clipboard
        cliphist
        udiskie
        xdg-desktop-portal-gtk
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
        fastfetch

        # NVIDIA GPU Fan Control
        nvidia-settings
        xorg-server
        xorg-xhost

        # Dependencies
        gtk3
        libxrandr
        clang
        cmake
        xdotool
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
        mission-center
        mcmojave-cursors
        zen-browser-bin
        visual-studio-code-bin
        obsidian
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
        mkdir -p ~/.local/share/fonts
        cd /tmp
        rm -f MapleMono-NF-CN.zip
        curl -fL "https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-CN.zip" -o MapleMono-NF-CN.zip
        unzip -o MapleMono-NF-CN.zip -d ~/.local/share/fonts/
        fc-cache -fv
    else
        log_info "Maple Mono уже установлен"
    fi

    # Playpen Sans
    if ! fc-list | grep -qi "playpen"; then
        log_info "Установка Playpen Sans..."
        mkdir -p ~/.local/share/fonts
        cd /tmp
        rm -rf Playpen-Sans
        git clone --depth=1 https://github.com/TypeTogether/Playpen-Sans.git
        cp Playpen-Sans/fonts/ttf/*.ttf ~/.local/share/fonts/ 2>/dev/null || true
        cp Playpen-Sans/fonts/variable/*.ttf ~/.local/share/fonts/ 2>/dev/null || true
        rm -rf Playpen-Sans
        fc-cache -fv
    else
        log_info "Playpen Sans уже установлен"
    fi

    # Nerd Fonts (дополнительно)
    sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd ttf-firacode-nerd 2>/dev/null || true

    # Emoji шрифт (для waybar иконок)
    sudo pacman -S --needed --noconfirm noto-fonts-emoji 2>/dev/null || true

    log_info "Шрифты установлены"
}

# ==========================================
# 5. Настройка sing-box VPN
# ==========================================
setup_singbox() {
    log_info "Настройка sing-box..."

    # Проверяем наличие sing-box
    if ! command -v sing-box &> /dev/null; then
        log_info "Установка sing-box..."
        sudo pacman -S --needed --noconfirm sing-box || {
            log_warn "sing-box не найден в pacman, пробуем AUR..."
            yay -S --noconfirm sing-box-bin || log_warn "Не удалось установить sing-box"
        }
    fi

    mkdir -p ~/.config/sing-box

    # Генерация конфига из VLESS ссылки
    if [[ ! -f "$HOME/.config/sing-box/config.json" ]]; then
        echo ""
        echo -e "${YELLOW}Вставь VLESS ссылку (vless://...) для настройки VPN:${NC}"
        echo -e "${YELLOW}(или нажми Enter чтобы пропустить)${NC}"
        read -r vless_link

        if [[ "$vless_link" == vless://* ]]; then
            # Парсим: vless://UUID@SERVER:PORT?params#fragment
            local userinfo="${vless_link#vless://}"
            local uuid="${userinfo%%@*}"
            local rest="${userinfo#*@}"
            local hostport="${rest%%\?*}"
            local server="${hostport%%:*}"
            local port="${hostport##*:}"
            local params="${rest#*\?}"
            params="${params%%#*}"

            # Извлекаем параметры
            local pbk="" fp="" sni="" sid=""
            IFS='&' read -ra PAIRS <<< "$params"
            for pair in "${PAIRS[@]}"; do
                local key="${pair%%=*}"
                local val="${pair#*=}"
                case "$key" in
                    pbk) pbk="$val" ;;
                    fp)  fp="$val" ;;
                    sni) sni="$val" ;;
                    sid) sid="$val" ;;
                esac
            done

            # Генерируем config.json из шаблона
            sed -e "s|YOUR_SERVER_IP|$server|g" \
                -e "s|YOUR_UUID_HERE|$uuid|g" \
                -e "s|YOUR_REALITY_PUBLIC_KEY|$pbk|g" \
                -e "s|YOUR_SHORT_ID|$sid|g" \
                -e "s|YOUR_USERNAME|$USER|g" \
                "$SCRIPT_DIR/.config/sing-box/config.json.example" | \
            python3 -c "
import sys, json
cfg = json.load(sys.stdin)
cfg['outbounds'][0]['server_port'] = $port
cfg['outbounds'][0]['tls']['server_name'] = '$sni'
cfg['outbounds'][0]['tls']['utls']['fingerprint'] = '$fp'
json.dump(cfg, sys.stdout, indent=2, ensure_ascii=False)
" > "$HOME/.config/sing-box/config.json"

            log_info "sing-box config.json сгенерирован из VLESS ссылки"
            log_info "  Сервер: $server:$port | SNI: $sni"
        else
            if [[ -n "$vless_link" ]]; then
                log_warn "Невалидная ссылка (должна начинаться с vless://)"
            fi
            log_warn "sing-box конфиг не создан. Создай вручную: ~/.config/sing-box/config.json"
        fi
    else
        log_info "sing-box config.json уже существует, пропускаем"
    fi

    # Sudoers для sing-box (без пароля)
    sudo tee /etc/sudoers.d/singbox > /dev/null << EOF
$USER ALL=(ALL) NOPASSWD: /usr/bin/sing-box, /usr/bin/pkill sing-box
EOF
    sudo chmod 440 /etc/sudoers.d/singbox

    log_info "sing-box настроен (используй Alt+P для toggle)"
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
# 6.1. Настройка системных вентиляторов (nct6798)
# ==========================================
setup_system_fan() {
    log_info "Настройка системных вентиляторов..."

    # Проверяем наличие nct6798
    if ! ls /sys/class/hwmon/hwmon*/name 2>/dev/null | xargs grep -l "nct6798" &>/dev/null; then
        # Загружаем модуль
        sudo modprobe nct6775 2>/dev/null || true
        echo nct6775 | sudo tee /etc/modules-load.d/nct6775.conf > /dev/null
        log_warn "Модуль nct6775 загружен. Может потребоваться перезагрузка."
    fi

    # Копируем скрипт
    sudo cp "$SCRIPT_DIR/scripts/setup-system-fan.sh" /usr/local/bin/system-fan-curve.sh
    sudo chmod +x /usr/local/bin/system-fan-curve.sh

    # Создаём systemd сервис
    sudo tee /etc/systemd/system/system-fan.service > /dev/null << 'EOF'
[Unit]
Description=System Fan Curve
After=systemd-modules-load.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/system-fan-curve.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable system-fan.service

    # Применяем сейчас
    sudo /usr/local/bin/system-fan-curve.sh 2>/dev/null || log_warn "Не удалось применить кривую (нужна перезагрузка?)"

    log_info "Системные вентиляторы настроены (nct6798)"
}

# ==========================================
# 6.2. Установка hk-translator
# ==========================================
install_hk_translator() {
    log_info "Установка hk-translator..."

    # Зависимость
    sudo pacman -S --needed --noconfirm python-evdev

    # Клонируем и копируем
    cd /tmp
    rm -rf hk-translator
    git clone --depth=1 https://github.com/reflaxess123/hk-translator.git
    sudo mkdir -p /opt/hk-translator
    sudo cp hk-translator/hk-translator.py /opt/hk-translator/
    sudo cp hk-translator/hk-translator.service /etc/systemd/system/

    # Включаем сервис
    sudo systemctl daemon-reload
    sudo systemctl enable hk-translator

    rm -rf /tmp/hk-translator

    log_info "hk-translator установлен (запустится после перезагрузки)"
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
# 7.5. Установка LazyVim
# ==========================================
install_lazyvim() {
    log_info "Установка LazyVim..."

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

    # Клонируем LazyVim starter
    log_info "Клонирование LazyVim..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git

    # Gruvbox Material с прозрачным фоном
    cat > ~/.config/nvim/lua/plugins/transparent.lua << 'NVIMEOF'
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_background = "hard"
    end,
  },
}
NVIMEOF

    log_info "LazyVim установлен (gruvbox-material). Запусти nvim для установки плагинов."
}

# ==========================================
# 8.5. Монтирование NTFS диска (nvme0n1p1)
# ==========================================
mount_ntfs_disk() {
    log_info "Настройка NTFS диска..."

    sudo modprobe ntfs3

    sudo mkdir -p /media/$USER/Storage

    if ! grep -q "7E68A3DE68A39405" /etc/fstab; then
        echo "UUID=7E68A3DE68A39405 /media/$USER/Storage ntfs3 defaults,force,nofail 0 0" | sudo tee -a /etc/fstab
        log_info "fstab запись добавлена"
    else
        log_info "fstab запись уже существует"
    fi

    if ! mountpoint -q /media/$USER/Storage; then
        sudo mount -t ntfs3 -o force /dev/nvme0n1p1 /media/$USER/Storage 2>/dev/null && \
            log_info "NTFS диск смонтирован в /media/$USER/Storage" || \
            log_warn "Не удалось смонтировать NTFS диск (возможно nvme0n1p1 отсутствует)"
    else
        log_info "NTFS диск уже смонтирован"
    fi
}

# ==========================================
# 9. Копирование конфигов
# ==========================================
copy_configs() {
    log_info "Копирование конфигов..."

    local items=(
        ".zshrc"
        ".p10k.zsh"
        ".config/hypr"
        ".config/ghostty"
        ".config/kitty"
        ".config/alacritty"
        ".config/swaykbdd"
        ".config/neofetch"
        ".config/scripts"
        ".config/Cursor"
        ".config/sing-box"
        ".config/waybar"
        ".config/rofi"
        ".config/niri"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".config/swaync"
        ".config/Code/User"
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
        sudo usermod -s /usr/bin/zsh "$USER"
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
    setup_gpu_fan
    setup_system_fan
    install_hk_translator
    install_ohmyzsh
    mount_ntfs_disk
    copy_configs
    setup_singbox
    make_scripts_executable
    install_lazyvim
    set_default_shell

    # Установка тёмной темы по умолчанию
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark'
    ln -sf "$HOME/.config/waybar/style-dark.css" "$HOME/.config/waybar/style.css"
    echo "dark" > "$HOME/.config/hypr/.theme-state"
    log_info "Тёмная тема установлена (переключение: Ctrl+Y)"

    # Перезагрузка Hyprland конфига и перезапуск панели/обоев
    hyprctl reload 2>/dev/null && log_info "Hyprland конфиг перезагружен" || true
    pkill waybar 2>/dev/null || true; waybar &disown
    pkill swww-daemon 2>/dev/null || true; swww-daemon &disown; sleep 1; swww img ~/wallpapers/15-Sequoia-Sunrise.png --transition-type none
    log_info "waybar и swww перезапущены"

    echo ""
    echo "=========================================="
    echo -e "${GREEN}  Установка завершена!${NC}"
    echo "=========================================="
    echo ""
    echo "Следующие шаги:"
    echo "  1. ПЕРЕЗАГРУЗИСЬ для применения GPU fan control и zsh"
    echo "  2. Запусти nvim для установки LazyVim плагинов"
    echo "  3. sing-box VPN toggle: Alt+P (не забудь настроить сервер в ~/.config/sing-box/config.json)"
    echo "  4. Проверь вентиляторы: nvidia-smi --query-gpu=fan.speed --format=csv"
    echo ""
}

main "$@"
