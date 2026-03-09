#!/bin/bash

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"

FILENAME="$(date '+%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$DIR/$FILENAME"

# 1. Сначала делаем скриншот и сохраняем в файл
scrot "$FULLPATH"

# 2. Копируем уже сохраненный файл в буфер обмена
xclip -selection clipboard -t image/png -i "$FULLPATH"

# 3. Уведомление
notify-send "Screenshot" "Файл <b>$FILENAME</b> сохранен и скопирован в буфер"


