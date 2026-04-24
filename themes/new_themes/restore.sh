#!/bin/bash

BACKUP_DIR="./backup"
LIST="files.conf"

while IFS=":" read -r NAME PATH; do
    [[ -z "$NAME" || "$NAME" =~ ^# ]] && continue

    eval "REAL_PATH=\"$PATH\""

    cp "$BACKUP_DIR/$NAME" "$REAL_PATH"
done < "$LIST"

