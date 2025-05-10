#!/bin/bash

# Подгружаем переменные из xrdb
eval "$(
  xrdb -query | grep -E '\*\.(color[0-9]{1,2}|background|foreground|cursorColor)' |
  sed 's/\*\.\(.*\):[[:space:]]*/export \1=/'
)"

# Подменяем переменные в ./template.toml на значения из xrdb
envsubst < ~/.config/rofi/template.rasi > ~/.config/rofi/alacritty.rasi
