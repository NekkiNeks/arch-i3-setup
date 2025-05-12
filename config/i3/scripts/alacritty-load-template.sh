#!/bin/bash

# Подменяем переменные в ./template.toml на значения из xrdb
envsubst < ~/.config/alacritty/template.toml > ~/.config/alacritty/alacritty.toml
