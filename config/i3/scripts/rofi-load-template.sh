#!/bin/bash

# Подменяем переменные в ./template.toml на значения из xrdb
envsubst < ~/.config/rofi/template.rasi > ~/.config/rofi/config.rasi
