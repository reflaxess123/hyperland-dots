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
    │       ├── voice-input.sh        # Voice-to-text (Ctrl+Super)
    │       ├── transcribe.py         # faster-whisper CUDA транскрибация
    │       ├── gpu-fan-control.sh    # NVIDIA fan control
    │       ├── singbox-toggle.sh     # VPN toggle
    │       ├── restart_hyprland.sh   # Restart waybar + swww + Hyprland
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
    │       ├── dark.conf     # Gruvbox Dark (opacity 0.8)
    │       └── light.conf    # Gruvbox Light (opacity 0.3)
    │
    ├── Code/User/            # VSCode настройки
    │   ├── settings.json     # Gruvbox Dark Hard / Bearded Milkshake Mint
    │   └── keybindings.json  # Кастомные хоткеи
    │
    ├── sing-box/             # VPN конфиг
    │   └── config.json.example  # Шаблон (без реальных данных!)
    │
    ├── swaync/               # Уведомления
    │   ├── config.json       # SwayNC конфиг
    │   └── style.css         # Gruvbox Dark стиль
    │
    ├── rofi/                 # App launcher (Gruvbox темы)
    ├── niri/                 # Niri compositor конфиг
    ├── kitty/                # Kitty терминал
    ├── alacritty/            # Alacritty терминал
    ├── gtk-3.0/              # GTK3 темы
    ├── gtk-4.0/              # GTK4 темы
    ├── neofetch/             # System info
    ├── swaykbdd/             # Per-window keyboard layout
    └── scripts/              # Общие скрипты
```

## Ключевые файлы

| Файл | Описание |
|------|----------|
| `.config/hypr/hyprland.conf` | Основной конфиг Hyprland |
| `.config/hypr/scripts/toggle-theme.sh` | Переключение dark/light (Ctrl+Y) |
| `.config/hypr/scripts/voice-input.sh` | Voice-to-text (Ctrl+Super) |
| `.config/hypr/scripts/transcribe.py` | faster-whisper транскрибация |
| `.config/waybar/config` | Waybar модули и layout |
| `.config/ghostty/config` | Ghostty терминал конфиг |
| `.config/Code/User/settings.json` | VSCode настройки |
| `.zshrc` | Shell конфиг + алиасы |
| `restore-config.sh` | Скрипт установки |

## Тема (Gruvbox)

Единая система тем на базе Gruvbox, переключение Ctrl+Y:

| Компонент | Dark | Light |
|-----------|------|-------|
| Ghostty | Gruvbox Dark (0.8 opacity) | Gruvbox Light (0.3 opacity) |
| Waybar | Gruvbox Dark monochrome | Gruvbox Light monochrome |
| VSCode | Gruvbox Dark Hard | Bearded Theme Milkshake Mint |
| Hyprland border | White (#ffffffcc) | White (#ffffffcc) |
| GTK | Adwaita:dark | Adwaita |
| Nvim | gruvbox-material (transparent) | gruvbox-material (transparent) |
| Rofi | Gruvbox Dark (muted #a89984) | — |
| SwayNC | Gruvbox Dark | — |

## Voice Input (faster-whisper)

Speech-to-text через CTRL+Super (toggle: первое нажатие — запись, второе — транскрибация).

- **Модель**: large-v3-turbo на CUDA (float16)
- **Venv**: `~/.local/share/voice-input/venv`
- **Индикатор**: красный ● в waybar (запись), жёлтый ● (обработка)
- **Вставка**: wl-copy + wtype (Ctrl+V в активное поле)

### Известные проблемы и решения

- **libcublas.so.12 not found**: ctranslate2 собран под CUDA 12, а в системе CUDA 13. Решение: `pip install nvidia-cublas-cu12 nvidia-cudnn-cu12` в venv, скрипт transcribe.py загружает их через ctypes перед импортом.
- **bindr не работает с Super_L**: `bindr = CTRL, Super_L` не срабатывает на отпускание. Решение: toggle-скрипт вместо hold-to-record (одно нажатие старт, второе стоп).
- **wtype не установлен**: текст попадает в буфер (wl-copy), но не вставляется. Решение: `sudo pacman -S wtype`.

## Ghostty — важные особенности

- **НЕТ hot-reload** — pkill -USR1 ghostty **крашит терминал**
- Тема применяется только при открытии нового окна
- toggle-theme.sh использует atomic write (tmpfile + mv) вместо sed -i
- Нельзя использовать `sed -i` на ghostty config — создаёт дубли строк

## Синхронизация конфигов

При изменении конфигов нужно обновлять **оба** места:
1. Repo: `~/hyperland-dots/.config/...`
2. Live: `~/.config/...`

Порядок: редактировать в repo → `cp` в live. Или наоборот если менял руками.

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
- nvim конфиг устанавливается отдельно (LazyVim) — restore создаёт transparent.lua
- LazyVim тема сбрасывается при повторном запуске restore (клонирует заново)
- NTFS диск (nvme0n1p1) монтируется в `/media/$USER/Storage` через fstab
