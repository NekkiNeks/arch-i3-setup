#!/bin/bash

BACKUP_DIR="./backup"
LIST="files.conf"

mkdir -p "$BACKUP_DIR"

while IFS=":" read -r NAME PATH; do
    [[ -z "$NAME" || "$NAME" =~ ^# ]] && continue

    eval "REAL_PATH=\"$PATH\""

    cp "$REAL_PATH" "$BACKUP_DIR/$NAME"
done < "$LIST"

