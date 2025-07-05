# 🚀 Arch Linux Hyprland Config

**Современный конфиг для Arch Linux с Hyprland, оптимизированный для производительности и красоты.**

## 📋 Обзор системы

Этот конфиг представляет собой полную настройку рабочего окружения на базе **Hyprland** с красивыми анимациями, удобными горячими клавишами и современными инструментами.

### 🎨 Основные компоненты

- **WM**: Hyprland (Wayland compositor)
- **Terminal**: Alacritty + Kitty
- **Shell**: ZSH + Oh My Zsh + Powerlevel10k
- **Panel**: Waybar
- **Launcher**: Wofi + Rofi
- **Notifications**: SwayNC
- **File Manager**: Yazi (TUI) + Nautilus (GUI)
- **Editor**: Neovim
- **Multiplexer**: Tmux

### 🌈 Тема

Все компоненты настроены в едином стиле **Catppuccin Mocha** с акцентом на:

- Темные тона и мягкие цвета
- Прозрачность и размытие
- Плавные анимации
- Консистентная цветовая схема

## 🔧 Зависимости

### Основные пакеты

```bash
# Система и WM
sudo pacman -S hyprland waybar wofi swaync alacritty kitty
sudo pacman -S tmux zsh neovim git

# Шрифты
sudo pacman -S ttf-jetbrains-mono-nerd

# Медиа и инструменты
sudo pacman -S swww hyprpaper hyprshot
sudo pacman -S pavucontrol blueman nm-applet

# Файловые менеджеры
sudo pacman -S nautilus yazi

# Современные замены утилит
sudo pacman -S exa bat fd ripgrep dust duf btop procs

# Дополнительные инструменты
sudo pacman -S fzf lazygit cliphist udiskie
```

### AUR пакеты

```bash
# Установка AUR helper (yay)
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

# AUR пакеты
yay -S cursor-appimage swww-git swaykbdd
```

### Oh My Zsh и плагины

```bash
# Установка Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Плагины
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

## 🎮 Горячие клавиши

### Hyprland (Модификатор: Alt)

#### Основные

- `Alt + W` - Открыть терминал
- `Alt + Q` - Закрыть окно
- `Alt + M` - Выйти из Hyprland
- `Alt + E` - Файловый менеджер
- `Alt + B` - Google Chrome
- `Alt + C` - Cursor IDE
- `Alt + Space` - Лаунчер приложений

#### Окна

- `Alt + T` - Переключить плавающий режим
- `Alt + J` - Переключить разделение
- `Alt + ←↑↓→` - Переход между окнами
- `Alt + 1-9` - Переключить рабочее пространство
- `Alt + Shift + 1-9` - Переместить в рабочее пространство

#### Медиа и скриншоты

- `Print` - Скриншот области
- `Alt + Ctrl + S` - Скриншот области
- `Alt + N` - Переключить уведомления

### ZSH

- `Ctrl + E` - Открыть nvim в текущей папке
- `Ctrl + G` - Запустить lazygit

### Tmux

- `Ctrl + B` - Префикс
- `|` - Разделить вертикально
- `-` - Разделить горизонтально
- `Alt + ←↑↓→` - Переключение между панелями
- `Alt + [` / `Alt + ]` - Переключение между окнами

## 📁 Структура конфигов

```
~/
├── .zshrc                    # Настройки ZSH
├── .tmux.conf               # Конфиг Tmux
├── .p10k.zsh               # Настройки Powerlevel10k
├── gpu-fan-control.sh      # Контроль вентиляторов GPU
├── sync-git.sh             # Синхронизация Git с VS Code
└── .config/
    ├── hypr/
    │   ├── hyprland.conf   # Основной конфиг Hyprland
    │   └── scripts/        # Скрипты для Hyprland
    ├── waybar/
    │   ├── config          # Конфиг панели
    │   ├── style.css       # Стили панели
    │   └── scripts/        # Скрипты для waybar
    │       └── leave.sh    # Меню выключения
    ├── alacritty/
    │   └── alacritty.toml  # Конфиг терминала
    ├── kitty/
    │   └── kitty.conf      # Альтернативный терминал
    ├── wofi/
    │   ├── config          # Конфиг лаунчера
    │   └── style.css       # Стили лаунчера
    ├── swaync/
    │   └── config.json     # Конфиг уведомлений
    ├── nvim/               # Конфиг Neovim
    └── neofetch/           # Конфиг системной информации
```

## 🛠️ Особенности конфигов

### Hyprland

- **Монитор**: 3440x1440@144Hz (ultrawide)
- **Анимации**: Плавные переходы с кастомными кривыми Безье
- **Размытие**: Включено для всех окон
- **Границы**: Градиентные оранжевые рамки
- **Раскладка**: US/RU с переключением по Caps Lock

### Waybar

- **Мониторинг**: CPU, GPU, память, диск, сеть
- **Температуры**: CPU и GPU в реальном времени
- **Языки**: Индикатор раскладки
- **Звук**: Ползунок громкости и микрофон
- **Меню**: Красивое меню выключения

### Alacritty

- **Тема**: Catppuccin Mocha
- **Прозрачность**: 36%
- **Шрифт**: JetBrainsMono Nerd Font 14pt
- **Отступы**: Увеличенные для комфорта

### ZSH

- **Алиасы**: Современные замены команд
  - `ls` → `exa` с иконками
  - `cat` → `bat` с подсветкой
  - `find` → `fd`
  - `grep` → `ripgrep`
  - `top` → `btop`
- **FZF**: Интерактивный поиск файлов и директорий
- **Автодополнение**: Умные подсказки

### Tmux

- **Тема**: Dracula
- **Мышь**: Включена
- **Статус**: Показывает сессию, время, дату
- **Навигация**: Alt + стрелки

## 🚀 Установка

1. **Клонируйте репозиторий**:

   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Установите зависимости**:

   ```bash
   # Основные пакеты
   sudo pacman -S hyprland waybar wofi swaync alacritty kitty tmux zsh neovim
   sudo pacman -S exa bat fd ripgrep dust duf btop procs fzf lazygit

   # AUR пакеты
   yay -S cursor-appimage swww-git
   ```

3. **Настройте ZSH**:

   ```bash
   # Установка Oh My Zsh
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

   # Клонирование плагинов
   git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
   ```

4. **Скопируйте конфиги**:

   ```bash
   cp -r .config/* ~/.config/
   cp .zshrc .tmux.conf .p10k.zsh ~/
   cp *.sh ~/
   ```

5. **Настройте права**:
   ```bash
   chmod +x ~/gpu-fan-control.sh
   chmod +x ~/sync-git.sh
   chmod +x ~/.config/waybar/scripts/leave.sh
   ```

## 📊 Производительность

### Системные требования

- **GPU**: NVIDIA (для gpu-fan-control.sh)
- **RAM**: 8GB+ рекомендуется
- **CPU**: Любой современный процессор
- **Диск**: 20GB+ для всех зависимостей

### Оптимизации

- Настроена автоматическая очистка кэша
- Оптимизированы анимации для плавности
- Включены аппаратные ускорения
- Настроен контроль вентиляторов GPU

## 🔧 Кастомизация

### Изменение темы

Все цвета находятся в соответствующих CSS файлах:

- `~/.config/waybar/style.css`
- `~/.config/wofi/style.css`
- `~/.config/alacritty/alacritty.toml`

### Добавление новых горячих клавиш

Редактируйте `~/.config/hypr/hyprland.conf` в секции `bind = `

### Настройка мониторов

Измените строку `monitor=` в `hyprland.conf` под ваше разрешение

## 🐛 Решение проблем

### Проблемы с шрифтами

```bash
fc-cache -fv
```

### Проблемы с Wayland

```bash
export XDG_SESSION_TYPE=wayland
```

### Проблемы с NVIDIA

```bash
export WLR_NO_HARDWARE_CURSORS=1
export LIBVA_DRIVER_NAME=nvidia
```

## 📝 Заметки

- Конфиг оптимизирован для NVIDIA GPU
- Поддерживает только Wayland
- Тестировался на Arch Linux
- Все скрипты написаны на Bash

## 🤝 Вклад

Не стесняйтесь создавать Issues или Pull Requests для улучшения конфигов!

---

**Автор**: [@crock](https://github.com/crock)  
**Лицензия**: MIT
