#!/bin/bash

# Функція для обробки папок та файлів
process_directory() {
    local current_directory="$1"

    # Переглядаємо всі файли та папки у поточній директорії
    for entry in "$current_directory"/*; do
        if [ -d "$entry" ]; then
            # Якщо це папка, рекурсивно викликаємо цю ж функцію
            process_directory "$entry"
        elif [ -f "$entry" ] && [[ "$entry" == *.xsh ]]; then
            # Якщо це файл .xsh, обробляємо його
            process_file "$entry"
        fi
    done
}

# Функція для обробки файлів .xsh
process_file() {
    local file="$1"

    # Конвертуємо файл з формату DOS у формат UNIX
    dos2unix "$file" > /dev/null 2>&1

    local group=$(basename "$(dirname "$file")")
    local label=$(basename "$file" .xsh)
    local hostname=$(grep -m 1 '^Host=' "$file" | sed 's/Host=//')
    local protocol=$(grep -m 1 '^Protocol=' "$file" | sed 's/Protocol=//')
    local port=$(grep -m 1 '^Port=' "$file" | sed 's/Port=//')

    # Записуємо дані у CSV файл
    echo "$group,$label,,$hostname,$protocol,$port" >> output.csv
}

# Визначаємо шлях до основної директорії
main_directory="/шлях/до/основної/папки"

# Визначаємо назви колонок у CSV файлі
echo "Groups,Label,Tags,Hostname/IP,Protocol,Port" > output.csv

# Викликаємо функцію для обробки основної директорії
process_directory "$main_directory"
