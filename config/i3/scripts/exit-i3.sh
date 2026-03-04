#!/bin/bash
# Убиваем процессы, которые могут опрашивать X11
pkill xsel
pkill xclip
pkill autocutsel

# Выходим из i3
notify-send "Выключение системы"
systemctl restart ly@tty2.service
