#!/bin/bash

# Скрипт для восстановления конфигурации
# Удаляет старые файлы/папки из ~ и копирует их из текущей директории

set -e  # Останавливаться при ошибках

echo "🔄 Начинаю восстановление конфигурации..."

# Список файлов и папок для восстановления
FILES_AND_DIRS=(
    ".zshrc"
    ".tmux.conf"
    ".p10k.zsh"
    "gpu-fan-control.sh"
    "sync-git.sh"
    ".config/nvim"
    ".config/hypr"
    ".config/waybar"
    ".config/kitty"
    ".config/ghostty"
    ".config/rofi"
    ".config/swaync"
    ".config/swaykbdd"
    ".config/neofetch"
    ".config/Cursor/User/keybindings.json"
    ".config/Cursor/User/settings.json"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/alacritty"
    ".config/wofi"
)

# Функция для удаления файлов/папок из домашней директории
remove_from_home() {
    local item="$1"
    local home_path="$HOME/$item"
    
    if [[ -e "$home_path" ]]; then
        echo "🗑️  Удаляю: $home_path"
        rm -rf "$home_path"
    else
        echo "ℹ️  Не найден: $home_path"
    fi
}

# Функция для копирования файлов/папок в домашнюю директорию
copy_to_home() {
    local item="$1"
    local current_path="./$item"
    local home_path="$HOME/$item"
    
    if [[ -e "$current_path" ]]; then
        # Создаём родительскую директорию, если нужно
        local parent_dir=$(dirname "$home_path")
        if [[ ! -d "$parent_dir" ]]; then
            echo "📁 Создаю директорию: $parent_dir"
            mkdir -p "$parent_dir"
        fi
        
        echo "📋 Копирую: $current_path -> $home_path"
        cp -r "$current_path" "$home_path"
    else
        echo "⚠️  Не найден в текущей директории: $current_path"
    fi
}

# Этап 1: Удаление старых файлов/папок
echo ""
echo "🗑️  Этап 1: Удаление старых файлов/папок из домашней директории"
echo "================================================"

for item in "${FILES_AND_DIRS[@]}"; do
    remove_from_home "$item"
done

# Этап 2: Копирование новых файлов/папок
echo ""
echo "📋 Этап 2: Копирование файлов/папок из текущей директории"
echo "================================================"

for item in "${FILES_AND_DIRS[@]}"; do
    copy_to_home "$item"
done

echo ""
echo "✅ Восстановление конфигурации завершено!"
echo "💡 Возможно, потребуется перезапустить некоторые приложения для применения изменений." 