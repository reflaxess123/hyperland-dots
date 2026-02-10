# Hyperland Dots

Dotfiles для Hyprland + waybar + swww + rofi на Arch Linux.

## Структура репозитория

```
hyperland-dots/
├── .zshrc                    # Zsh конфиг (Oh My Zsh + Powerlevel10k + алиасы)
├── .p10k.zsh                 # Powerlevel10k конфиг
├── restore-config.sh         # Скрипт полной установки системы
├── README.md                 # Документация
├── CLAUDE.md                 # Этот файл
│
└── .config/
    ├── hypr/                 # Hyprland конфиг
    │   ├── hyprland.conf     # Основной конфиг
    │   └── scripts/          # Скрипты автоматизации
    │       ├── toggle-theme.sh       # Dark/Light theme toggle (Ctrl+Y)
    │       ├── gpu-fan-control.sh    # NVIDIA fan control
    │       ├── singbox-toggle.sh     # VPN toggle
    │       ├── restart_hyprland.sh   # Restart waybar + swww + Hyprland
    │       ├── claude-usage.sh       # Claude API usage widget
    │       ├── get-keyboard-layout.sh # Current keyboard layout
    │       └── workspace-switch.sh   # Multi-monitor workspace switch
    │
    ├── waybar/               # Waybar панель
    │   ├── config            # Модули и layout
    │   ├── style-dark.css    # Gruvbox Dark тема
    │   ├── style-light.css   # Gruvbox Light тема
    │   ├── style.css         # Симлинк на активную тему
    │   └── scripts/          # Скрипты для модулей
    │       ├── singbox-status.sh  # sing-box status
    │       └── leave.sh           # Power menu
    │
    ├── ghostty/              # Ghostty терминал
    │   ├── config            # Основной конфиг
    │   └── themes/           # Gruvbox темы
    │       ├── dark.conf     # Gruvbox Dark (opacity 0.6)
    │       └── light.conf    # Gruvbox Light (opacity 0.3)
    │
    ├── Code/User/            # VSCode настройки
    │   └── settings.json     # Gruvbox Dark Hard / Bearded Milkshake Mint
    │
    ├── sing-box/             # VPN конфиг
    │   └── config.json.example  # Шаблон (без реальных данных!)
    │
    ├── niri/                 # Niri compositor конфиг
    │   └── config.kdl
    │
    ├── kitty/                # Kitty терминал
    ├── alacritty/            # Alacritty терминал
    ├── rofi/                 # App launcher темы
    ├── gtk-3.0/              # GTK3 темы
    ├── gtk-4.0/              # GTK4 темы
    ├── neofetch/             # System info
    ├── swaykbdd/             # Per-window keyboard layout
    ├── scripts/              # Общие скрипты
    └── Cursor/               # Cursor IDE keybindings
```

## Ключевые файлы

| Файл | Описание |
|------|----------|
| `.config/hypr/hyprland.conf` | Основной конфиг Hyprland |
| `.config/hypr/scripts/toggle-theme.sh` | Переключение dark/light (Ctrl+Y) |
| `.config/waybar/config` | Waybar модули и layout |
| `.config/ghostty/config` | Ghostty терминал конфиг |
| `.config/Code/User/settings.json` | VSCode настройки |
| `.config/sing-box/config.json.example` | Шаблон VPN конфига |
| `.zshrc` | Shell конфиг + алиасы |
| `restore-config.sh` | Скрипт установки |

## Тема (Gruvbox)

Единая система тем на базе Gruvbox, переключение Ctrl+Y:

| Компонент | Dark | Light |
|-----------|------|-------|
| Ghostty | Gruvbox Dark (0.6 opacity) | Gruvbox Light (0.3 opacity) |
| Waybar | Gruvbox Dark monochrome | Gruvbox Light monochrome |
| VSCode | Gruvbox Dark Hard | Bearded Theme Milkshake Mint |
| Hyprland border | White (#ffffffcc) | White (#ffffffcc) |
| GTK | Adwaita:dark | Adwaita |
| Nvim | gruvbox-material (transparent) | gruvbox-material (transparent) |

## Zsh алиасы

| Алиас | Описание |
|-------|----------|
| `cu` | Claude Code usage (лимиты API) |
| `disk` | Обзор дисков |
| `space` | Топ-20 по размеру в текущей папке |
| `vpn-log` | Sing-box лог в реалтайме |
| `vpn-traffic` | Только proxy/direct трафик |

## Важно

- **sing-box/config.json** исключён из git (содержит приватные данные)
- Используй `config.json.example` как шаблон
- nvim конфиг устанавливается отдельно (LazyVim)
- Ghostty не поддерживает hot-reload — тема применяется при новом окне
