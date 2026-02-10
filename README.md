# Мои Dotfiles для Hyprland

Персональная конфигурация для Hyprland + waybar + swww + rofi на Arch Linux.

## Особенности

- **Waybar** — минималистичная панель с Gruvbox цветами
- **Gruvbox тема** — единый стиль для ghostty, waybar, VSCode, nvim, GTK
- **Dark/Light toggle** — переключение всех тем по Ctrl+Y
- **Плавные анимации** — настроенные bezier curves для окон и workspaces
- **VPN с split tunneling** — sing-box (VLESS + Reality), .ru домены напрямую
- **NVIDIA GPU fan control** — динамическое управление вентиляторами на Wayland
- **LazyVim** — nvim с прозрачным gruvbox-material

## Быстрая установка

```bash
git clone https://github.com/reflaxess123/hyperland-dots ~/hyperland-dots
cd ~/hyperland-dots
chmod +x restore-config.sh
./restore-config.sh
```

Скрипт установит все зависимости, настроит конфиги, waybar, swww, LazyVim.

## Сочетания клавиш

### Основные

| Клавиша | Действие |
|---------|----------|
| `Alt + W` | Терминал (ghostty) |
| `Alt + Q` | Закрыть окно |
| `Alt + M` | Выход из Hyprland |
| `Alt + E` | Файловый менеджер (nautilus) |
| `Alt + Space` | Лаунчер (rofi) |
| `Alt + V` | Буфер обмена (cliphist + rofi) |
| `Alt + F` | Fullscreen |
| `Alt + T` | Toggle floating |
| `Alt + S` | Pin window |
| `Ctrl + Y` | Toggle dark/light тема |

### VPN и система

| Клавиша | Действие |
|---------|----------|
| `Alt + P` | Toggle VPN (sing-box) |
| `Alt + Ctrl + T` | Mission Center |
| `Alt + Ctrl + W` | Restart Hyprland + waybar + swww |
| `Print` / `Alt + Ctrl + S` | Скриншот области |

### Навигация (Vim-style)

| Клавиша | Действие |
|---------|----------|
| `Alt + H/J/K/L` | Фокус между окнами |
| `Alt + Shift + H/J/K/L` | Переместить окно |
| `Alt + Ctrl + H/J/K/L` | Resize окна |
| `Alt + 1-9, 0` | Workspace 1-10 |
| `Alt + Ctrl + 1-9` | Переместить на workspace |

## Тема (Gruvbox)

Единая система тем с переключением по Ctrl+Y:

| Компонент | Dark | Light |
|-----------|------|-------|
| Ghostty | Gruvbox Dark (0.6 opacity) | Gruvbox Light (0.3 opacity) |
| Waybar | Gruvbox Dark monochrome | Gruvbox Light monochrome |
| VSCode | Gruvbox Dark Hard | Bearded Theme Milkshake Mint |
| Nvim | gruvbox-material transparent | gruvbox-material transparent |
| GTK | Adwaita:dark | Adwaita |

## sing-box VPN

VPN на основе VLESS + Reality с split tunneling.

- .ru домены идут напрямую
- Остальной трафик через VPN
- DNS over HTTPS (Google)

```bash
# Настройка через restore-config.sh (вставить VLESS ссылку)
# Или вручную:
cp ~/.config/sing-box/config.json.example ~/.config/sing-box/config.json
nano ~/.config/sing-box/config.json
```

## NVIDIA GPU Fan Control

Скрипт `gpu-fan-control.sh` + systemd сервис для управления вентиляторами.

| Температура | Скорость |
|-------------|----------|
| ≤ 35°C | 40% |
| 50°C | 58% |
| 70°C | 82% |
| ≥ 85°C | 100% |

## System Fan Curve (nct6798)

Кастомная кривая для системных вентиляторов через hwmon (nct6798). Systemd сервис при загрузке.

| CPU температура | Скорость |
|-----------------|----------|
| ≤ 30°C | 20% |
| 40°C | 25% |
| 48°C | 50% |
| 55°C | 90% |
| ≥ 58°C | 100% |

## Структура

```
.config/
├── hypr/                 # Hyprland + скрипты
├── waybar/               # Панель (Gruvbox dark/light CSS)
├── ghostty/              # Терминал + themes/
├── Code/User/            # VSCode settings
├── sing-box/             # VPN (только шаблон!)
├── niri/                 # Niri compositor
├── kitty/                # Терминал
├── alacritty/            # Терминал
├── rofi/                 # Launcher темы
├── gtk-3.0/              # GTK темы
└── gtk-4.0/              # GTK темы
```
