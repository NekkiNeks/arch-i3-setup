#!/bin/bash

# Настройки
STEP=5
SINK="@DEFAULT_SINK@"
MAX_VOLUME=100

# Получить текущую громкость (в процентах)
get_volume() {
  pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%'
}

# Проверить, заглушен ли звук
is_muted() {
  pactl get-sink-mute "$SINK" | grep -q "yes"
}

# Установить громкость с ограничением
set_volume() {
  local new_volume=$1
  if [ "$new_volume" -gt "$MAX_VOLUME" ]; then
    new_volume=$MAX_VOLUME
  fi
  pactl set-sink-volume "$SINK" "${new_volume}%"
}

# Уменьшить громкость
decrease_volume() {
  pactl set-sink-volume "$SINK" "-${STEP}%"
}

# Вывод громкости с иконкой
print_volume() {
  vol=$(get_volume)

  if [ "$vol" -ge 100 ]; then
    icon=""
  elif [ "$vol" -ge 80 ]; then
    icon=""
  elif [ "$vol" -ge 60 ]; then
    icon=""
  elif [ "$vol" -ge 40 ]; then
    icon=""
  elif [ "$vol" -ge 20 ]; then
    icon=""
  elif [ "$vol" -ge 1 ]; then
    icon=""
  else
    icon=""
  fi

  if is_muted; then
    echo " muted"
  else
    echo "$icon $vol%"
  fi
}

# Обработка аргументов
case "$1" in
  up)
    current=$(get_volume)
    set_volume $((current + STEP))
    ;;
  down)
    decrease_volume
    ;;
  mute)
    pactl set-sink-mute "$SINK" toggle
    ;;
esac

# Всегда выводим текущее значение
print_volume