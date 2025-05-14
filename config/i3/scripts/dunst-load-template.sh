#!/bin/bash

# Подменяем переменные в ./template на значения из xrdb
envsubst < ~/.config/dunst/template > ~/.config/dunst/dunstrc
