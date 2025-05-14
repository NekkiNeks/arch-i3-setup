#!/bin/bash

# Каталог для скриншотов
DIR="$HOME/Pictures/screenshots"

# Создать каталог, если не существует
mkdir -p "$DIR"

# Получить текущую дату и время
FILENAME="$(date '+%Y-%m-%d_%H-%M-%S').jpg"

# Сделать скриншот всего экрана с сохранением в файл
scrot -F "$DIR/$FILENAME"

notify-send "Screenshot" "file <b>$FILENAME</b> saved in <b>$DIR</b>"
