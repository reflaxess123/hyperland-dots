# Hyperland Dots

Dotfiles для Hyprland, Niri, DankMaterialShell и Caelestia Shell.

## Структура репозитория

```
hyperland-dots/
├── .zshrc                    # Zsh конфиг (Oh My Zsh + Powerlevel10k + алиасы)
├── .tmux.conf.local          # Oh My Tmux настройки (Catppuccin Mocha theme)
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
    ├── caelestia/            # Caelestia Shell конфиг (альтернатива DMS)
    │   └── shell.json        # Настройки шелла
    │
    ├── kitty/                # Kitty терминал
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
| `.config/caelestia/shell.json` | Настройки Caelestia Shell |
| `.config/sing-box/config.json.example` | Шаблон VPN конфига |
| `.tmux.conf.local` | Tmux настройки (Catppuccin theme) |
| `.zshrc` | Shell конфиг + алиасы |
| `restore-config.sh` | Скрипт установки |

## Zsh алиасы

| Алиас | Описание |
|-------|----------|
| `t` | Tmux attach или new session |
| `cu` | Claude Code usage (лимиты API) |
| `disk` | Обзор дисков |
| `space` | Топ-20 по размеру в текущей папке |
| `vpn-log` | Sing-box лог в реалтайме |
| `vpn-traffic` | Только proxy/direct трафик |

## Важно

- **sing-box/config.json** исключён из git (содержит приватные данные)
- Используй `config.json.example` как шаблон
- **DMS** и **Caelestia Shell** — альтернативные desktop shells
- Переключение между ними: `~/.config/hypr/scripts/switch-shell.sh`
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
