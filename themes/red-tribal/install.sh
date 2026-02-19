#!/usr/bin/env bash
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="$(basename "$THEME_DIR")"

echo "Theme: $THEME_NAME"

# -------------------------
# Xresources
# -------------------------
cp "$THEME_DIR/Xresources" \
    ~/.Xresources
xrdb ~/.Xresources

# -------------------------
# i3
# -------------------------
mkdir -p ~/.config/i3/config.d
cp "$THEME_DIR/config/i3/appearance.conf" \
   ~/.config/i3/config.d/appearance.conf

# -------------------------
# polybar
# -------------------------
mkdir -p ~/.config/polybar
cp "$THEME_DIR/config/polybar/config.ini" \
   ~/.config/polybar/config.ini

# -------------------------
# wallpapers (nitrogen)
# -------------------------
WALL_DEST="$HOME/Pictures/themed_wallpapers/$THEME_NAME"
mkdir -p "$WALL_DEST"

# копируем с подменой (но не удаляем папку)
rsync -av "$THEME_DIR/wallpapers/" "$WALL_DEST/"

# переменные окружения для template.cfg
export WALL1="$WALL_DEST/wallpaper_1.png"
export WALL2="$WALL_DEST/wallpaper_2.png"

# генерируем bg-saved.cfg из template
envsubst < "$THEME_DIR/config/nitrogen/template.cfg" \
         > "$THEME_DIR/config/nitrogen/bg-saved.cfg"

mkdir -p ~/.config/nitrogen
cp "$THEME_DIR/config/nitrogen/bg-saved.cfg" \
   ~/.config/nitrogen/bg-saved.cfg

# -------------------------
# templates без подстановки
# -------------------------
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/dunst

cp "$THEME_DIR/templates/rofi/template.rasi" \
   ~/.config/rofi/template.rasi

cp "$THEME_DIR/templates/alacritty/template.toml" \
   ~/.config/alacritty/template.toml

cp "$THEME_DIR/templates/dunst/template" \
   ~/.config/dunst/template

echo "Theme installed"

# --------------------
# 4. Reload i3
# --------------------
echo "Reload i3"
i3-msg reload
i3-msg restart
