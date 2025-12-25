# Hyperland Dots

Dotfiles для Hyprland, Niri и связанных утилит.

## Структура

```
.config/
├── hypr/           # Hyprland конфиг и скрипты
├── niri/           # Niri compositor конфиг
├── waybar/         # Статус бар
├── rofi/           # Лаунчер
├── wofi/           # Альтернативный лаунчер
├── ghostty/        # Терминал
├── kitty/          # Терминал (запасной)
├── alacritty/      # Терминал (запасной)
├── nvim/           # Neovim (NvChad)
├── swaync/         # Центр уведомлений
├── gtk-3.0/        # GTK темы
├── gtk-4.0/        # GTK4 темы
├── qt5ct/          # Qt5 темы
├── qt6ct/          # Qt6 темы
├── sing-box/       # VPN конфиг
└── neofetch/       # System info
```

## Ключевые файлы для проверки

- `.config/hypr/hyprland.conf` — основной конфиг Hyprland
- `.config/niri/config.kdl` — конфиг Niri
- `.config/nvim/lua/configs/lspconfig.lua` — LSP серверы
- `.config/nvim/lua/mappings.lua` — хоткеи Neovim
- `.config/waybar/config` — модули waybar
- `.tmux.conf.local` — Oh My Tmux настройки
- `.zshrc` — shell конфиг

## Как обновить

```bash
cd ~/hyperland-dots
git add -A
git commit -m "Описание изменений"
git push
```

## Важно

- Эта репа — ручная копия конфигов
- Для автоматического управления используй **chezmoi** (репа `newdots`)
- При изменении конфигов обновляй обе репы
