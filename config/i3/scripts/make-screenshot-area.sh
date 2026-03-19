#!/bin/bash

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"

FILENAME="$(date '+%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$DIR/$FILENAME"

# 1. Используем slop для получения координат и scrot для снимка области
# Флаг -f '%x,%y,%w,%h' передает координаты в нужном для scrot формате
scrot -a $(slop -f '%x,%y,%w,%h') "$FULLPATH"

# Проверка: если пользователь нажал ESC (slop вернул пустоту), выходим из скрипта
[ $? -ne 0 ] && exit 1

# 2. Копируем уже сохраненный файл в буфер обмена
xclip -selection clipboard -t image/png -i "$FULLPATH"

# 3. Уведомление
notify-send "Screenshot" "Область сохранена в <b>$FILENAME</b> и скопирована"


