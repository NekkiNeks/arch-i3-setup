#!/bin/bash

# 1. Скриншот
DIR="$HOME/Pictures/wallust_screenshots"
mkdir -p "$DIR"
FULLPATH="$DIR/theme_$(date '+%Y%m%d_%H%M%S').png"

AREA=$(slop -f '%x,%y,%w,%h') || exit 1
scrot -a "$AREA" "$FULLPATH"

# 2. Генерация и захват вывода в переменную
# 2>&1 перенаправляет ошибки в основной поток, чтобы мы точно поймали текст палитры
export WALLUST_OUTPUT=$(wallust run "$FULLPATH" 2>&1)

# 3. Обновление ресурсов X11
xrdb -merge ~/.Xresources

# 4. Перезапуск i3
i3-msg restart

# 5. Перезапуск Polybar
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
polybar main & >/dev/null 2>&1

# 6. Перезапуск Dunst
killall -q dunst
dunst & >/dev/null 2>&1

# 7. Вывод палитры в Alacritty через переменную
# Мы передаем переменную внутрь оболочки терминала
alacritty --class floating_shell \
          -o window.dimensions.columns=82 \
          -o window.dimensions.lines=25 \
          -e sh -c "echo \"$WALLUST_OUTPUT\"; echo; echo 'press ENTER...'; read" &
