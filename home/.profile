### .profile используется как и ,bashrc, но при этом запускается для системного sh один раз при логине ###
### Здесь стоит записывать самые основные переменные окружения, которые нужны system-wide ###

export PATH="$HOME/.local/bin/:$PATH"       # Папка .bin для хранения Appimage файлов
export EDITOR=nvim                          # Текстовый редактор по умолчанию
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"     # Настройка для легаси GTK2 приложений

# Основные переменные XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Настройка для тем QT приложений
export QT_QPA_PLATFORMTHEME=qt6ct
