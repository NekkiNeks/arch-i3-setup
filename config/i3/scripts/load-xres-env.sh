#!/bin/bash

# Данный скрипт позволяет получить значения .Xresources и поместить их в переменные окружения с приставкой

# Список нужных Xresources-свойств
properties=(color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15 background foreground cursorColor)

# Перебираем и экспортируем в переменные окружения
for prop in "${properties[@]}"; do
  value=$(xgetres "$prop")
  if [[ -n $value ]]; then
    export "$prop=$value"
  fi
done


