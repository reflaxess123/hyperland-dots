# Мои Dotfiles для Hyprland

Это моя персональная конфигурация для Hyprland, Wayland-композитора.

## Особенности

*   **Минималистичный и чистый вид:** Конфигурация нацелена на минимализм, с использованием `dwindle` лэйаута.
*   **Анимации:** Плавные и приятные анимации для окон, рабочих столов и слоев.
*   **Удобные хоткеи:** Продуманные сочетания клавиш для управления окнами, приложениями и системой.
*   **Скрипты:** Набор полезных скриптов для автоматизации задач.

## Установка

1.  **Клонировать репозиторий:**
    ```bash
    git clone <URL-вашего-репозитория> ~/.config/hypr
    ```
2.  **Установить зависимости:**
    *   `hyprland`
    *   `waybar`
    *   `wofi`
    *   `swww`
    *   `swaync`
    *   `ghostty` (или ваш любимый терминал)
    *   `nautilus` (или ваш любимый файловый менеджер)
    *   `google-chrome-stable`
    *   `pavucontrol`
    *   `wl-paste`
    *   `cliphist`
    *   `udiskie`
    *   `eww`
    *   `hyprshot`
    *   `redsocks` (опционально, для скрипта `socks-toggle.sh`)

3.  **Сделать скрипты исполняемыми:**
    ```bash
    chmod +x ~/.config/hypr/scripts/*.sh
    ```

## Сочетания клавиш

| Клавиша                  | Действие                                           |
| ------------------------ | -------------------------------------------------- |
| `Alt + W`                | Открыть терминал (`ghostty`)                       |
| `Alt + Q`                | Закрыть активное окно                              |
| `Alt + M`                | Выйти из Hyprland                                  |
| `Alt + Ctrl + W`         | Перезагрузить Hyprland и все компоненты            |
| `Alt + E`                | Открыть файловый менеджер (`nautilus`)             |
| `Alt + B`                | Открыть браузер (`google-chrome-stable`)           |
| `Alt + T`                | Переключить активное окно в плавающий режим        |
| `Alt + Shift + T`        | Переключить активное окно в плавающий режим (альтернативный) |
| `Alt + Ctrl + B`         | Открыть Brave в режиме Wayland                     |
| `Alt + Ctrl + T`         | Открыть `missioncenter`                            |
| `Alt + Space`            | Открыть меню приложений (`wofi`)                   |
| `Alt + O`                | Открыть `obs`                                      |
| `Alt + C`                | Открыть `cursor.appimage`                          |
| `Alt + N`                | Открыть/закрыть центр уведомлений (`swaync`)       |
| `Alt + F`                | Переключить полноэкранный режим для активного окна |
| `Alt + Shift + W`        | Установить следующие обои                          |
| `Alt + H/J/K/L`          | Переместить фокус между окнами (как в Vim)         |
| `Alt + Shift + H/J/K/L`  | Переместить активное окно                          |
| `Alt + Ctrl + H/J/K/L`   | Изменить размер активного окна                     |
| `Alt + V`                | Включить/выключить прокси (redsocks)               |
| `Alt + Shift + D`        | Показать/скрыть EWW виджет                         |
| `Alt + Y`                | Сменить тему Waybar                                |
| `Alt + 1-9, 0`           | Переключиться на рабочий стол 1-10                 |
| `Alt + Shift + 1-9, 0`   | Переместить активное окно на рабочий стол 1-10      |
| `Print Screen`           | Сделать скриншот области и скопировать в буфер обмена |
| `Alt + Ctrl + S`         | Сделать скриншот области и скопировать в буфер обмена |
| `Alt + Scroll Down`      | Переключиться на следующий рабочий стол            |
| `Alt + Scroll Up`        | Переключиться на предыдущий рабочий стол           |

## Скрипты

*   `restart_hyprland.sh`: Перезагружает Hyprland, Waybar, swaync и другие компоненты.
*   `socks-toggle.sh`: Включает и выключает системный прокси с помощью `redsocks` и `iptables`.
*   `wall-next.sh`: Устанавливает случайные обои из папки `~/wallpapers`.
*   `gpu-fan-control.sh`: Управление вентиляторами NVIDIA GPU (см. раздел ниже).

## NVIDIA GPU Fan Control на Wayland

### Динамическая кривая вентиляторов

Скрипт `gpu-fan-control.sh` автоматически управляет скоростью вентиляторов GPU в зависимости от температуры:

| Температура | Скорость вентилятора |
|-------------|---------------------|
| ≤ 35°C      | 40%                 |
| 50°C        | 58%                 |
| 70°C        | 82%                 |
| ≥ 85°C      | 100%                |

Линейная интерполяция между точками с гистерезисом 3% для предотвращения частых переключений.

### Как это работает

Скрипт использует **XWayland** который уже запущен в Hyprland:

1. `xhost si:localuser:root` — разрешает root доступ к X дисплею
2. `nvidia-settings` — устанавливает скорость вентиляторов через XWayland
3. `xhost -si:localuser:root` — убирает разрешение

Это работает потому что Hyprland автоматически запускает XWayland на `:0`.

### Установка

```bash
# 1. Установить зависимости
sudo pacman -S nvidia-settings xorg-xhost

# 2. Добавить sudoers правило (без пароля для nvidia-settings)
echo '$USER ALL=(ALL) NOPASSWD: /usr/bin/nvidia-settings' | sudo tee /etc/sudoers.d/nvidia-settings

# 3. Скрипт уже настроен на автозапуск через exec-once в hyprland.conf
```

### Проверка

```bash
# Логи демона
tail -f ~/.local/share/gpu-fan.log

# Текущая скорость и температура
nvidia-smi --query-gpu=fan.speed,temperature.gpu --format=csv
```

### Настройка кривой

Отредактируйте `~/.config/hypr/scripts/gpu-fan-control.sh`:

```bash
TEMP_MIN=35   # Температура для минимальной скорости
TEMP_MAX=85   # Температура для максимальной скорости
FAN_MIN=40    # Минимальная скорость (%)
FAN_MAX=100   # Максимальная скорость (%)
INTERVAL=5    # Интервал проверки (секунды)
```

### Требования

- `nvidia-settings`
- `xorg-xhost`
- NVIDIA GPU с проприетарным драйвером
- Sudoers правило для nvidia-settings

## Управление яркостью монитора (DDC/CI)

Waybar поддерживает управление яркостью монитора через DDC/CI протокол.

### Установка

```bash
# 1. Установить ddcutil
sudo pacman -S ddcutil

# 2. Загрузить модуль i2c-dev
sudo modprobe i2c-dev

# 3. Добавить пользователя в группу i2c
sudo usermod -aG i2c $USER

# 4. Для автозагрузки модуля
echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c-dev.conf

# 5. Перелогиниться для применения группы
```

### Проверка

```bash
# Определить монитор
ddcutil detect

# Текущая яркость
ddcutil getvcp 10

# Установить яркость 50%
ddcutil setvcp 10 50
```

### Управление в Waybar

- **Скролл** на иконке яркости — изменение ±10%
- **Клик на +/-** — изменение ±10%

### Требования

- Монитор с поддержкой DDC/CI (большинство современных мониторов)
- Подключение через DisplayPort или HDMI
- `ddcutil`
- Пользователь в группе `i2c`

## GRUB с темой Catppuccin и Dual Boot

### Установка

```bash
# 1. Установить os-prober для обнаружения Windows
sudo pacman -S os-prober

# 2. Примонтировать Windows EFI раздел (найти через lsblk)
sudo mount /dev/nvme1n1p4 /mnt/win_efi

# 3. Скачать тему Catppuccin
git clone https://github.com/catppuccin/grub.git /tmp/catppuccin-grub
sudo mkdir -p /boot/grub/themes
sudo cp -r /tmp/catppuccin-grub/src/catppuccin-mocha-grub-theme /boot/grub/themes/

# 4. Редактировать /etc/default/grub:
sudo nano /etc/default/grub
```

### Настройки /etc/default/grub

```bash
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT=30
GRUB_GFXMODE=1920x1080,1280x720,auto
GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
GRUB_DISABLE_OS_PROBER=false
```

### Применение

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Результат

- Windows и Arch Linux в меню загрузки
- Тема Catppuccin Mocha
- Запоминает последний выбор
- Таймаут 30 секунд

## Конфигурация

Основной файл конфигурации - `hyprland.conf`. В нем вы можете настроить:

*   **Мониторы:** разрешение, частоту обновления и расположение.
*   **Переменные:** терминал, файловый менеджер, меню и браузер по умолчанию.
*   **Автозапуск:** приложения, которые запускаются вместе с Hyprland.
*   **Оформление:** отступы, рамки, тени, размытие и скругление.
*   **Анимации:** настройка анимаций для окон, рабочих столов и слоев.
*   **Лэйауты:** `dwindle` и `master`.
*   **Устройства ввода:** настройки клавиатуры, мыши и тачпада.
*   **Жесты:** настройка жестов для тачпада.
*   **Правила для окон:** специфичные правила для определенных приложений.
*   **Слои:** правила для слоев Wayland (например, для `wofi` и `eww`).
