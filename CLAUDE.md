# Hyperland Dots

Dotfiles для Hyprland, Niri и DankMaterialShell.

## Структура репозитория

```
hyperland-dots/
├── .zshrc                    # Zsh конфиг (Oh My Zsh + Powerlevel10k)
├── .tmux.conf.local          # Oh My Tmux настройки (Dracula theme)
├── .p10k.zsh                 # Powerlevel10k конфиг
├── restore-config.sh         # Скрипт полной установки системы
├── README.md                 # Документация
├── CLAUDE.md                 # Этот файл
│
└── .config/
    ├── hypr/                 # Hyprland конфиг
    │   ├── hyprland.conf     # Основной конфиг
    │   └── scripts/          # Скрипты автоматизации
    │       ├── gpu-fan-control.sh      # NVIDIA fan control
    │       ├── singbox-toggle.sh       # VPN toggle
    │       ├── socks-toggle.sh         # SOCKS proxy toggle
    │       ├── restart_hyprland.sh     # Restart DMS + Hyprland
    │       ├── claude-usage.sh         # Claude API usage widget
    │       ├── get-keyboard-layout.sh  # Current keyboard layout
    │       └── wall-select.sh          # Wallpaper selector
    │
    ├── niri/                 # Niri compositor конфиг
    │   └── config.kdl
    │
    ├── DankMaterialShell/    # Desktop shell (панель, лаунчер, уведомления)
    │   ├── settings.json     # Основные настройки
    │   ├── plugin_settings.json  # Настройки виджетов
    │   └── plugins/          # Кастомные плагины
    │       ├── treesize-dms/ # Disk scanner виджет
    │       ├── vpnStatus/    # VPN status виджет
    │       └── dankActions/  # Custom actions виджет
    │
    ├── sing-box/             # VPN конфиг
    │   └── config.json.example  # Шаблон (без реальных данных!)
    │
    ├── kitty/                # Kitty терминал (Dracula colors)
    ├── ghostty/              # Ghostty терминал
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
| `.config/niri/config.kdl` | Конфиг Niri compositor |
| `.config/DankMaterialShell/settings.json` | Настройки DMS |
| `.config/sing-box/config.json.example` | Шаблон VPN конфига |
| `.tmux.conf.local` | Tmux настройки |
| `.zshrc` | Shell конфиг |
| `restore-config.sh` | Скрипт установки |

## Важно

- **sing-box/config.json** исключён из git (содержит приватные данные)
- Используй `config.json.example` как шаблон
- DMS заменяет waybar, swaync, rofi, swww
- nvim конфиг устанавливается отдельно (NvChad)

## Как обновить

```bash
cd ~/hyperland-dots
git add -A
git commit -m "Описание изменений"
git push
```

## Связанные репозитории

- **chezmoi** (`~/.local/share/chezmoi`) — автоматическое управление dotfiles
- **treesize-dms** — плагин Disk Scanner для DMS
- **vpnstatus** — плагин VPN Status для DMS
