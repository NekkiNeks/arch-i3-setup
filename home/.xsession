#!/bin/bash
# Здесь можно вызывать переменные окружения глобально

export VIMINIT='source $HOME/.config/vim/.vimrc'
source $HOME/.config/i3/scripts/load-xres-env.sh

notify-send "xres color0: " $xres_color0
