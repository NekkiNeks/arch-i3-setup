#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Читаем шаблон целиком в переменную
content=$(<"$SCRIPT_DIR/template")

# Запрашиваем данные из xrdb, убираем звездочки/точки/пробелы
while read -r line; do
    # Получаем чистое имя (например, background) и значение (например, #1a1b26)
    prop=$(echo "$line" | awk -F: '{print $1}' | tr -d ' *.')
    value=$(echo "$line" | awk '{print $2}')

    # Делаем замену встроенными средствами Bash (безопасно для любых символов)
    content="${content//\${$prop\}/$value}"
done < <(xrdb -query | grep -E '(color[0-9]+|background|foreground|cursorColor):')

# Записываем готовый результат в default
echo "$content" > "$SCRIPT_DIR/default"
