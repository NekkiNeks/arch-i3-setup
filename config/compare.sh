#!/usr/bin/env bash

set -o nounset

LOG_FILE="./diff.log"
TARGET_BASE="$HOME/.config"

# Флаг для скрытия подробностей в терминале (0 - показывать, 1 - скрыть)
SUMMARY_ONLY=0

# Обработка аргументов командной строки
for arg in "$@"; do
    case "$arg" in
        -s|--summary-only)
            SUMMARY_ONLY=1
            shift
            ;;
    esac
done

# Очищаем лог при старте
: > "$LOG_FILE"

# Массивы для сбора статистики в конце скрипта
CHANGED_DIRS=()
FAILED_DIRS=()
IDENTICAL_COUNT=0

echo "=== Запуск сравнения конфигураций ==="
echo "Текстовый лог пишется в: $LOG_FILE"
[ "$SUMMARY_ONLY" -eq 1 ] && echo "[Режим: Только список измененных папок]"
echo "---------------------------------------"

for dir in *; do
    if [ -d "$dir" ]; then
        # Пропускаем скрытые папки (.git и т.д.)
        case "$dir" in .*) continue ;; esac

        # Убираем слэш из имени для вывода
        dir_name="${dir%/}"

        # Проверяем существование папки в ~/.config
        if [ ! -d "$TARGET_BASE/$dir_name" ]; then
            {
                echo "========================================================================="
                echo " СРАВНЕНИЕ ПАПКИ: $dir_name [ОШИБКА]"
                echo "========================================================================="
                echo "Папка назначения $TARGET_BASE/$dir_name не существует."
                echo -e "\n\n"
            } >> "$LOG_FILE"
            
            [ "$SUMMARY_ONLY" -eq 0 ] && echo "ПРОВЕРКА: $dir_name  <->  [НЕ НАЙДЕНА В ~/.config]"
            FAILED_DIRS+=("$dir_name (не найдена в ~/.config)")
            continue
        fi

        [ "$SUMMARY_ONLY" -eq 0 ] && echo "ПРОВЕРКА: $dir_name  <->  $TARGET_BASE/$dir_name"

        # Временный файл для вывода diff
        TMP_DIFF=$(mktemp)

        # Сравниваем содержимое файлов
        diff -ruN "$dir_name" "$TARGET_BASE/$dir_name" > "$TMP_DIFF"
        DIFF_STATUS=$?

        if [ "$DIFF_STATUS" -eq 0 ]; then
            IDENTICAL_COUNT=$((IDENTICAL_COUNT + 1))
            [ "$SUMMARY_ONLY" -eq 0 ] && echo "  └─ Изменений не обнаружено (папки идентичны)."
        elif [ "$DIFF_STATUS" -eq 1 ]; then
            # Добавляем папку в список изменившихся
            CHANGED_DIRS+=("$dir_name")

            # 1. Вывод в терминал (зависит от флага)
            if [ "$SUMMARY_ONLY" -eq 1 ]; then
                echo "[ИЗМЕНЕНА] Папка: $dir_name"
            else
                echo "  └─ Обнаружены различия! Вывожу на экран..."
                echo ""
                cat "$TMP_DIFF" | delta
            fi

            # 2. В лог всегда пишем полную информацию, независимо от флага
            {
                echo "========================================================================="
                echo " ИЗМЕНЕНИЯ В ПАПКЕ: $dir_name"
                echo " Источник: $PWD/$dir_name"
                echo " Цель:     $TARGET_BASE/$dir_name"
                echo "========================================================================="
                cat "$TMP_DIFF"
                echo -e "\n\n"
            } >> "$LOG_FILE"
        else
            [ "$SUMMARY_ONLY" -eq 0 ] && echo "  └─ [ОШИБКА] Не удалось выполнить diff."
            FAILED_DIRS+=("$dir_name (ошибка выполнения diff)")
        fi

        rm -f "$TMP_DIFF"
        [ "$SUMMARY_ONLY" -eq 0 ] && echo ""
    fi
done

# =========================================================================
# БЛОК ИТОГОВОГО РЕЗЮМЕ В КОНЦЕ
# =========================================================================
echo "---------------------------------------"
echo "=== ИТОГ ПРОВЕРКИ ==="
echo "---------------------------------------"
echo " Идентичных папок: $IDENTICAL_COUNT"

# Выводим список папок с ошибками/отсутствующих
if [ ${#FAILED_DIRS[@]} -ne 0 ]; then
    echo -e "\n Не удалось проверить папки:"
    for f_dir in "${FAILED_DIRS[@]}"; do
        echo "  ❌ $f_dir"
    done
fi

# Выводим список папок, где контент файлов РАЗЛИЧАЕТСЯ
if [ ${#CHANGED_DIRS[@]} -ne 0 ]; then
    echo -e "\n Обнаружены несоответствия в контенте папок:"
    for c_dir in "${CHANGED_DIRS[@]}"; do
        echo "  ⚠️  $c_dir"
    done
else
    echo -e "\n Поздравляем! Все проверенные папки полностью соответствуют."
fi

echo "---------------------------------------"
echo "Полный текстовый отчет сохранен в: $LOG_FILE"
