#!/usr/bin/env bash

IFS=$'\n'

# Временно отключаем nounset (флаг -u), чтобы скрипт не падал из-за пустых переменных
set -o noclobber -o noglob -o pipefail

FILE_PATH=""
PREVIEW_WIDTH=10
PREVIEW_HEIGHT=10

# Парсинг флагов-аргументов
while [ "$#" -gt 0 ]; do
    case "$1" in
        --path)           FILE_PATH="$2"; shift ;;
        --preview-width)  PREVIEW_WIDTH="$2"; shift ;;
        --preview-height) PREVIEW_HEIGHT="$2"; shift ;;
    esac
    shift
done

# Защита от пустого вызова
if [ -z "$FILE_PATH" ]; then
    echo "Ошибка: joshuto не передал путь к файлу"
    exit 0
fi

# Получаем расширение и MIME-тип
FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}" 2>/dev/null || echo "unknown")"

# --- UTILS ---

get_image_info() {
    echo "Image info:"
    exiftool -ImageSize -FileSize -FileType -MimeType -S "$FILE_PATH" 2>/dev/null
}

save_meta_file_info() {
    local key_name=$1
    local value=$2
    local meta_file
    
    meta_file=$(get_preview_meta_file "$FILE_PATH")
    echo "$key_name $value" >> "$meta_file"
}

# --- HANDLERS ---
image_handler() {
    local meta_file
    meta_file=$(get_preview_meta_file "$FILE_PATH")
    
    :> "$meta_file"

    local text_data=$(get_image_info)
    local line_count
    line_count=$(echo "$text_data" | wc -l)
    y_offset=$((line_count + 1))

    save_meta_file_info "handle_data" "true"
    save_meta_file_info "file_type" "image"
    save_meta_file_info "y_offset" "$y_offset"

    echo "$text_data"
}

archive_handler() {
    atool --list -- "${FILE_PATH}" && return 0
    bsdtar --list --file "${FILE_PATH}" && return 0
    return 1
}

rar_handler() {
    unrar lt -p- -- "${FILE_PATH}" && return 0
    return 1
}

7z_handler() {
    7z l -p -- "${FILE_PATH}" && return 0
    return 1
}

pdf_handler() {
    pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w "${PREVIEW_WIDTH}" && return 0
    mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | fmt -w "${PREVIEW_WIDTH}" && return 0
    exiftool "${FILE_PATH}" && return 0
    return 1
}

torrent_handler() {
    transmission-show -- "${FILE_PATH}" && return 0
    return 1
}

open_document_handler() {
    odt2txt "${FILE_PATH}" && return 0
    pandoc -s -t markdown -- "${FILE_PATH}" && return 0
    return 1
}

excel_handler() {
    xlsx2csv -- "${FILE_PATH}" && return 0
    return 1
}

html_handler() {
    w3m -dump "${FILE_PATH}" && return 0
    lynx -dump -- "${FILE_PATH}" && return 0
    elinks -dump "${FILE_PATH}" && return 0
    pandoc -s -t markdown -- "${FILE_PATH}" && return 0
    return 1
}

json_handler() {
    jq --color-output . "${FILE_PATH}" && return 0
    python -m json.tool -- "${FILE_PATH}" && return 0
    return 1
}

dsd_handler() {
    mediainfo "${FILE_PATH}" && return 0
    exiftool "${FILE_PATH}" && return 0
    return 1
}

books_handler() {
    # Рендерим книги через pandoc и bat (бывший docx_epub_handler)
    pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
        --color=always --paging=never \
        --style=plain \
        --terminal-width="${PREVIEW_WIDTH}" && return 0
    return 1
}

media_handler() {
    mediainfo "${FILE_PATH}" && return 0
    exiftool "${FILE_PATH}" && return 0
    return 1
}

text_handler() {
    bat --color=always --paging=never \
        --style=plain \
        --terminal-width="${PREVIEW_WIDTH}" \
        "${FILE_PATH}" && return 0
    cat "${FILE_PATH}" && return 0
    return 1
}

# --- LOGIC ---
handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        a|ace|alz|arc|\
        arj|bz|bz2|cab|\
        deb|cpio|gz|jar|\
        lha|rpm|lzh|lzma|\
        lzo|tZ|rz|t7z|tar|\
        tbz|tbz2|Z|tlz|txz|\
        rlz|tzo|war|xpi|tgz|\
        xz|zip)                     archive_handler;        exit $?;;
        json|jsonc|jsonb|ipynb)     json_handler;           exit $?;;
        jpg|jpeg|png|gif|bmp)       image_handler;          exit $?;;
        odt|ods|odp|sxw)            open_document_handler;  exit $?;;
        htm|html|xhtml)             html_handler;           exit $?;;
        dff|dsf|wv|wvc)             dsd_handler;            exit $?;;
        config|conf|rc)             text_handler;           exit $?;;
        epub|fb2)                   books_handler;          exit $?;;
        xlsx|xls)                   excel_handler;          exit $?;;
        torrent)                    torrent_handler;        exit $?;;
        rar)                        rar_handler;            exit $?;;
        pdf)                        pdf_handler;            exit $?;;
        7z)                         7z_handler;             exit $?;;
    esac
}

handle_mime() {
    local text_mimetypes="^text/|/xml$|application/javascript|application/json"

    if [[ "${MIMETYPE}" =~ $text_mimetypes ]]; then
        text_handler ; exit $?
    else
        # Безопасный и лаконичный вывод через код возврата cat
        cat "${FILE_PATH}" ; exit $?
    fi
}

# Запуск конвейера обработки
handle_extension
handle_mime

exit 1
