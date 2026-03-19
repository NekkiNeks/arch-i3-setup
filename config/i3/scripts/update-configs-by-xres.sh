#!/bin/bash

# 1. Обновляем Xresources
xrdb -merge ~/.Xresources

# Убеждаемся, что отработало корректно
if [ $? -ne 0 ]; then
    echo "xrdb merge failed" >&2
    notify-send "xrdb merge failed" >&2
    exit 1
fi

# Подгружаем переменные из xres в переменные окружения
source $HOME/.config/i3/scripts/load-xres-env.sh

# Обновляем конфиги на основе template с использованием переменных окружения
$HOME/.config/alacritty/apply-template.sh   # alacritty
$HOME/.config/rofi/apply-template.sh        #rofi
$HOME/.config/dunst/apply-template.sh       #dunst
$HOME/.config/gtt/apply-template.sh         #gtt
$HOME/.config/vimium/apply-template.sh      #vimium
