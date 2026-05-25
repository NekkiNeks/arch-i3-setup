#!/usr/bin/env bash

set -o nounset

TARGET_BASE="$HOME/.config"
DIR_NAME="${1:-}"

# 1. Проверяем, передан ли аргумент
if [ -z "$DIR_NAME" ]; then
    echo "Ошибка: Не указано имя папки для обновления."
    echo "Использование: $0 имя_папки"
    exit 1
fi

# Убираем слэш в конце, если он есть
DIR_NAME="${DIR_NAME%/}"

# Определяем пути
LOCAL_CONFIG="./$DIR_NAME"
LOCAL_TEMP="./${DIR_NAME}_tempname"
CONFIG_SOURCE="$TARGET_BASE/$DIR_NAME"

# 2. Проверяем, существует ли папка-источник в ~/.config/
if [ ! -d "$CONFIG_SOURCE" ]; then
    echo "Ошибка: Папка '$DIR_NAME' не найдена в $TARGET_BASE"
    exit 1
fi

echo "=== Обновление локальной папки: $DIR_NAME ==="

# 3. Безопасная замена локальной папки
if [ -d "$LOCAL_CONFIG" ]; then
    echo "1. Переименовываю старую локальную папку в ${DIR_NAME}_tempname..."
    mv "$LOCAL_CONFIG" "$LOCAL_TEMP"
    
    echo "2. Копирую актуальный конфиг из ~/.config/ в текущую папку..."
    cp -r "$CONFIG_SOURCE" "$LOCAL_CONFIG"
    
    echo "3. Удаляю временную локальную папку..."
    rm -rf "$LOCAL_TEMP"
else
    # Если локальной папки почему-то не было рядом, просто копируем её туда из .config
    echo "Локальная папка рядом со скриптом не найдена. Создаю её копированием из ~/.config/..."
    cp -r "$CONFIG_SOURCE" "$LOCAL_CONFIG"
fi

echo "=== Обновление локальной папки '$DIR_NAME' успешно завершено! ==="
