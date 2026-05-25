#!/bin/bash

# 1. Проверяем, передан ли аргумент (пустая ли строка $1)
if [ -z "$1" ]; then
    echo "Введите цвет (например: 282828)"
    exit 1
fi

ffmpeg -f lavfi -i color=c=0x$1:s=1920x1080 -vframes 1 /home/nekzie/.config/nitrogen/bg.png -y
