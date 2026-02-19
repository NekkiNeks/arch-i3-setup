#!/usr/bin/env bash
set -e

# -------------------------
# аргумент
# -------------------------
THEME_NAME="$1"

if [ -z "$THEME_NAME" ]; then
  echo "Usage: ./save-theme.sh THEME_NAME"
  exit 1
fi

BASE_DIR="$(pwd)"
NEW_THEME_DIR="$BASE_DIR/$THEME_NAME"

echo "Saving theme -> $NEW_THEME_DIR"

mkdir -p "$NEW_THEME_DIR"

# -------------------------
# install.sh из default
# -------------------------
if [ -f "$BASE_DIR/default/install.sh" ]; then
  cp "$BASE_DIR/default/install.sh" "$NEW_THEME_DIR/install.sh"
  chmod +x "$NEW_THEME_DIR/install.sh"
fi

# -------------------------
# Xresources
# -------------------------
cp ~/.Xresources "$NEW_THEME_DIR/Xresources"

# -------------------------
# config
# -------------------------
mkdir -p "$NEW_THEME_DIR/config/i3"
mkdir -p "$NEW_THEME_DIR/config/polybar"
mkdir -p "$NEW_THEME_DIR/config/nitrogen"

# i3
if [ -f ~/.config/i3/config.d/appearance.conf ]; then
  cp ~/.config/i3/config.d/appearance.conf \
     "$NEW_THEME_DIR/config/i3/appearance.conf"
fi

# polybar
if [ -f ~/.config/polybar/config.ini ]; then
  cp ~/.config/polybar/config.ini \
     "$NEW_THEME_DIR/config/polybar/config.ini"
fi

# nitrogen template берём из default
cp "$BASE_DIR/default/config/nitrogen/template.cfg" \
   "$NEW_THEME_DIR/config/nitrogen/template.cfg"

# -------------------------
# templates
# -------------------------
mkdir -p "$NEW_THEME_DIR/templates/rofi"
mkdir -p "$NEW_THEME_DIR/templates/alacritty"
mkdir -p "$NEW_THEME_DIR/templates/dunst"

# rofi
if [ -f ~/.config/rofi/template.rasi ]; then
  cp ~/.config/rofi/template.rasi \
     "$NEW_THEME_DIR/templates/rofi/template.rasi"
fi

# alacritty
if [ -f ~/.config/alacritty/template.toml ]; then
  cp ~/.config/alacritty/template.toml \
     "$NEW_THEME_DIR/templates/alacritty/template.toml"
fi

# dunst
if [ -f ~/.config/dunst/template ]; then
  cp ~/.config/dunst/template \
     "$NEW_THEME_DIR/templates/dunst/template"
fi

# -------------------------
# wallpapers (пусто)
# -------------------------
mkdir -p "$NEW_THEME_DIR/wallpapers"

echo
echo "Wallpaper folder created:"
echo "$NEW_THEME_DIR/wallpapers"
echo "Сохраните изображения как:"
echo "  wallpaper_1.jpg"
echo "  wallpaper_2.jpg"

echo "Theme saved"
