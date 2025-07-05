#!/bin/bash

# Скрипт для автоматической синхронизации files.exclude в VS Code/Cursor
# с файлами, которые НЕ отслеживаются Git

SETTINGS_FILE="$HOME/.config/Cursor/User/settings.json"
TEMP_FILE="/tmp/settings_temp.json"

echo "🔄 Синхронизация files.exclude с Git..."

# Получаем список всех файлов/папок в домашней директории
cd "$HOME" || exit 1

# Получаем все файлы и папки в корне (включая скрытые)
all_root_items=$(find . -maxdepth 1 -name ".*" -o -maxdepth 1 -name "*" | grep -v "^\.$" | sed 's|^\./||' | sort)

# Получаем все папки и файлы в .config
all_config_items=""
if [ -d ".config" ]; then
    all_config_items=$(find .config -maxdepth 1 ! -path ".config" | sed 's|^\./||' | grep -v "^\.config$" | sort)
fi

# Получаем список отслеживаемых Git файлов
tracked_files=$(git ls-files)
tracked_root=$(echo "$tracked_files" | cut -d'/' -f1 | sort -u)
tracked_config=$(echo "$tracked_files" | grep "^\.config/" | cut -d'/' -f2 | sort -u)

# Файлы, которые НЕ отслеживаются Git и должны быть в exclude
exclude_items=""

# Обрабатываем корневые элементы
for item in $all_root_items; do
    # Пропускаем если это отслеживаемый файл/папка
    if echo "$tracked_root" | grep -q "^$item$"; then
        continue
    fi
    
    # Пропускаем скрытые файлы системы
    case "$item" in
        ".git"|".gitignore"|".")
            continue
            ;;
    esac
    
    exclude_items="$exclude_items    \"$item\": true,\n"
done

# Обрабатываем папки и файлы в .config
for item in $all_config_items; do
    config_name=$(basename "$item")
    
    # Пропускаем если это отслеживаемая папка/файл в .config
    if echo "$tracked_config" | grep -q "^$config_name$"; then
        continue
    fi
    
    exclude_items="$exclude_items    \"$item\": true,\n"
done

# Добавляем стандартные системные исключения
standard_excludes='    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,'

# Создаем новый файл настроек
awk -v excludes="$standard_excludes\n$exclude_items" '
/^  "files\.exclude": \{/ {
    print $0
    print excludes
    # Пропускаем старые настройки до закрывающей скобки
    while (getline > 0 && !/^  \},?$/) continue
    print "  },"
    next
}
{print}
' "$SETTINGS_FILE" > "$TEMP_FILE"

# Заменяем файл
mv "$TEMP_FILE" "$SETTINGS_FILE"

echo "✅ Синхронизация завершена!"
echo "📁 Исключены из отображения:"
echo "$exclude_items" | sed 's/    "//g;s/": true,//g' | grep -v "^$"