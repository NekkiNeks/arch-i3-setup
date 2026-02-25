#!/bin/bash

# Нужно для того чтобы относительный путь всегда работал правильно
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подменяем переменные в ./template на значения из xrdb
envsubst < "$SCRIPT_DIR/template.rasi" > "$SCRIPT_DIR/config.rasi"
