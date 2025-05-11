#!/bin/bash

# Убиваем все экземпляры polybar
killall -q polybar

# Ждём завершения
while pgrep -x polybar >/dev/null; do sleep 1; done

# Подгружаем переменные из .Xresources
eval "$(
  xrdb -query | grep -E '\*\.(color[0-9]{1,2}|background|foreground|cursorColor)' |
  sed 's/\*\.\(.*\):[[:space:]]*/export \1=/' 
)"


# Запускаем polybar
polybar default &
