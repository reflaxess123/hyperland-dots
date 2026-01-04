# Мои Dotfiles для Hyprland

Персональная конфигурация для Hyprland + DankMaterialShell / Caelestia Shell на Arch Linux.

## Особенности

- **DankMaterialShell** или **Caelestia Shell** — два desktop shell на выбор
- **Минималистичный дизайн** — dwindle layout, Catppuccin Mocha акценты
- **Плавные анимации** — настроенные bezier curves для окон и workspaces
- **VPN с split tunneling** — sing-box (VLESS + Reality), .ru домены напрямую
- **NVIDIA GPU fan control** — динамическое управление вентиляторами на Wayland
- **Кастомные DMS плагины** — VPN статус, Disk Scanner, GPU мониторинг

## Быстрая установка

```bash
# Клонировать репозиторий
git clone https://github.com/reflaxess123/hyperland-dots ~/hyperland-dots

# Запустить скрипт установки
cd ~/hyperland-dots
chmod +x restore-config.sh
./restore-config.sh
```

Скрипт установит все зависимости, настроит конфиги и DMS плагины.

## Сочетания клавиш

### Основные

| Клавиша | Действие |
|---------|----------|
| `Alt + W` | Терминал (kitty) |
| `Alt + Q` | Закрыть окно |
| `Alt + M` | Выход из Hyprland |
| `Alt + E` | Файловый менеджер (nautilus) |
| `Alt + Space` | Лаунчер (DMS Spotlight) |
| `Alt + Tab` | Обзор workspaces |
| `Alt + F` | Fullscreen |
| `Alt + T` | Toggle floating |
| `Alt + D` | Pseudo (tiling) |
| `Alt + S` | Pin window |

### VPN и система

| Клавиша | Действие |
|---------|----------|
| `Alt + P` | Toggle VPN (sing-box) |
| `Alt + I` | Toggle SOCKS proxy |
| `Alt + Ctrl + T` | Mission Center |
| `Alt + Ctrl + W` | Restart Hyprland + DMS |
| `Alt + Ctrl + A` | Выбор обоев |

### DMS панели

| Клавиша | Действие |
|---------|----------|
| `Alt + N` | Уведомления |
| `Alt + V` | Буфер обмена |
| `Alt + X` | Меню выключения |
| `Alt + O` | OBS Studio |

### Навигация (Vim-style)

| Клавиша | Действие |
|---------|----------|
| `Alt + H/J/K/L` | Фокус между окнами |
| `Alt + Shift + H/J/K/L` | Переместить окно |
| `Alt + Ctrl + H/J/K/L` | Resize окна |
| `Alt + 1-9, 0` | Workspace 1-10 |
| `Alt + Ctrl + 1-9` | Переместить на workspace |

### Скриншоты

| Клавиша | Действие |
|---------|----------|
| `Print` | Скриншот области |
| `Alt + Ctrl + S` | Скриншот области |

## DankMaterialShell

Desktop shell заменяет waybar, swaync, rofi и swww единым интерфейсом.

### Кастомные виджеты

В панели настроены виджеты через плагин dankActions:
- **VPN** — статус sing-box, клик для toggle
- **GPU** — температура и скорость вентилятора NVIDIA
- **VRAM** — использование видеопамяти
- **Disk** — занятое место, клик для tree view

### IPC команды

```bash
dms ipc call spotlight toggle      # Лаунчер
dms ipc call notifications toggle  # Уведомления
dms ipc call clipboard toggle      # Буфер обмена
dms ipc call powermenu toggle      # Меню выключения
dms ipc call hypr toggleOverview   # Обзор workspaces
dms ipc call dankdash wallpaper    # Выбор обоев
```

## Caelestia Shell

Альтернативный desktop shell на базе Quickshell. Переключение:

```bash
~/.config/hypr/scripts/switch-shell.sh
```

### Особенности

- Прозрачность с blur
- Температура в °C
- Dashboard с системной информацией (Alt+Tab)

### Горячие клавиши Caelestia

| Клавиша | Действие |
|---------|----------|
| `Alt + Space` | Launcher |
| `Alt + N` | Sidebar |
| `Alt + V` | Utilities |
| `Alt + X` | Session menu |
| `Alt + Tab` | Dashboard |
| `Alt + Ctrl + A` | Random wallpaper |

## sing-box VPN

VPN на основе VLESS + Reality с split tunneling.

### Особенности

- .ru домены идут напрямую
- Telegram идёт напрямую
- Avito, hCaptcha идут напрямую
- Остальной трафик через VPN
- DNS over HTTPS (Google)

### Настройка

```bash
# Скопировать шаблон
cp ~/.config/sing-box/config.json.example ~/.config/sing-box/config.json

# Отредактировать — указать свои данные:
# - YOUR_SERVER_IP
# - YOUR_UUID_HERE
# - YOUR_REALITY_PUBLIC_KEY
# - YOUR_SHORT_ID
nano ~/.config/sing-box/config.json

# Добавить sudoers правило
echo 'vasya ALL=(ALL) NOPASSWD: /usr/bin/sing-box, /usr/bin/pkill sing-box' | sudo tee /etc/sudoers.d/singbox
sudo chmod 440 /etc/sudoers.d/singbox
```

### Проверка

```bash
tail -f ~/.local/share/singbox.log  # Логи
curl ifconfig.me                     # Проверить IP
```

## NVIDIA GPU Fan Control

Скрипт `gpu-fan-control.sh` динамически управляет вентиляторами GPU.

| Температура | Скорость |
|-------------|----------|
| ≤ 35°C | 40% |
| 50°C | 58% |
| 70°C | 82% |
| ≥ 85°C | 100% |

### Требования

```bash
sudo pacman -S nvidia-settings xorg-xhost
echo '$USER ALL=(ALL) NOPASSWD: /usr/bin/nvidia-settings' | sudo tee /etc/sudoers.d/nvidia-settings
```

### Логи

```bash
tail -f ~/.local/share/gpu-fan.log
nvidia-smi --query-gpu=fan.speed,temperature.gpu --format=csv
```

## Структура репозитория

```
.config/
├── hypr/                 # Hyprland + скрипты
├── niri/                 # Niri compositor
├── DankMaterialShell/    # DMS + плагины
├── caelestia/            # Caelestia Shell настройки
├── sing-box/             # VPN (только шаблон!)
├── kitty/                # Терминал
├── ghostty/              # Терминал
├── alacritty/            # Терминал
├── rofi/                 # Launcher темы
├── gtk-3.0/              # GTK темы
└── gtk-4.0/              # GTK темы
```

## Зависимости

### Pacman

```bash
hyprland kitty nautilus rofi papirus-icon-theme
nm-applet pavucontrol wl-clipboard cliphist udiskie
nvidia-settings xorg-xhost sing-box
```

### AUR

```bash
yay -S dms-shell-hyprland hyprshot mcmojave-cursors
```

## GRUB (Dual Boot)

```bash
# Установить тему Catppuccin
git clone https://github.com/catppuccin/grub.git /tmp/catppuccin-grub
sudo cp -r /tmp/catppuccin-grub/src/catppuccin-mocha-grub-theme /boot/grub/themes/

# /etc/default/grub
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT=30
GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
GRUB_DISABLE_OS_PROBER=false

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Связанные репозитории

- [treesize-dms](https://github.com/reflaxess123/treesize-dms) — DMS плагин Disk Scanner
- [vpnstatus](https://github.com/reflaxess123/vpnstatus) — DMS плагин VPN Status
