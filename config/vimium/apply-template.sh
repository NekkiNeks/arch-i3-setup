#!/bin/bash

# Загружаем переменные из .Xresources в окружение
source ../i3/scripts/load-xres-env.sh

# Нужно для того чтобы относительный путь всегда работал правильно
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подменяем переменные в ./template.toml на значения из xrdb
envsubst < "$SCRIPT_DIR/template.css" > "$SCRIPT_DIR/config.css"
