#!/bin/bash

# Список нужных Xresources-свойств
properties=(color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15 background foreground cursorColor)

# Перебираем и экспортим в переменные окружения с заменой # → 0x
for prop in "${properties[@]}"; do
  value=$(xgetres "$prop")
  if [[ -n $value ]]; then
    value="0x${value#\#}"  # убираем # и добавляем 0x
    export "$prop=$value"
  fi
done

# Нужно для того чтобы относительный путь всегда работал правильно
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подменяем переменные в ./template на значения из xrdb
envsubst < "$SCRIPT_DIR/template.yaml" > "$SCRIPT_DIR/theme.yaml"
