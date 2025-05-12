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

# Обновляем конфиг alacritty на основе template с использованием переменных окружения
$HOME/.config/i3/scripts/alacritty-load-template.sh

# Обновляем конфиг rofi на основе template с использованием переменных окружения
$HOME/.config/i3/scripts/rofi-load-template.sh

notify-send "Скрипт обновления конфигураций успешно выполнен"