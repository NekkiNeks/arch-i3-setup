
### CUSTOM PATH VARIABLES ###
export PATH="$PATH:$HOME/.local/bin/"       # Папка .bin для хранения Appimage файлов
export PATH="$PATH:$HOME/.local/bin/scripts"       # Папка .bin для хранения Appimage файлов

source "$HOME/.profile"

### OTHER VARIABLES ###
export EDITOR=nvim                          # Основной редактор текста
export SYSTEMD_EDITOR=nvim                  # Редактор текста для systemd и systemctl

### GOLANG VARIABLES ###
export GOPATH=$HOME/.local/share/go         # Устанавливаем новый путь для рабочей области
export GOMODCACHE=$HOME/.cache/go-build/    # Кэш golang
export PATH=$PATH:$GOPATH/bin               # чтобы установленные через 'go install' утилиты были доступны в терминале
export PATH=$PATH:/usr/local/go/bin         # Путь к основному бинарнику go

### NVM VARIABLES ###
export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


### ANDROID STUDIO VARIABLES ###
export ANDROID_HOME=$HOME/Documents/utils/android-studio/sdk/
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$XDG_DATA_HOME/cargo/bin

### RUST VARIABLES ###
source "$HOME/.local/share/cargo/env" # Подключение sh файла с переменными

### НАСТРОЙКА RUST ДЛЯ XTENZA (ESP И ARDUINO) ###
if [ -f "$HOME/.local/share/esp-tools/export-esp.sh" ]; then
    . "$HOME/.local/share/esp-tools/export-esp.sh" > /dev/null
fi

### ALIASES ###
alias gosleep='systemctl suspend'
alias tt="ghostty --working-directory=\"\$PWD\" >/dev/null 2>&1 &"
alias tj='ghostty --working-directory="$PWD" --command="bash -c \"joshuto; exec bash\"" >/dev/null 2>&1 &'
alias jj='source joshuto-wrapper'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings' # clean-up alias
#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less

### CLEAN-UP ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PLATFORMIO_HOME_DIR="$XDG_DATA_HOME/platformio"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"
export CRAWL_DIR="$XDG_DATA_HOME"/crawl/
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export SQLITE_HISTORY="$XDG_STATE_HOME"/sqlite_history
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc.py
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# TODO: update in i3-wizard to .local/share - themes, fonts, icons


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Строка для автозаполнения по кнопке TAB
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

##### НАСТРОЙКА ШАБЛОНА ГЛАВНОЙ СТРОКИ #####
# ==============================================================================
# ШПАРГАЛКА ПО ПЕРЕМЕННЫМ PS1 (Bash Prompt):
# ------------------------------------------------------------------------------
# \u  -> Имя пользователя          \h  -> Имя хоста
# \w  -> Полный путь (с ~)         \W  -> Только текущая папка
# \$  -> Символ $ или #            \n  -> Перенос строки
# \t  -> Время HH:MM:SS            \[..\] -> Обертка невидимых кодов
# ==============================================================================

# 1. Библиотека цветов (Палитра)
COLOR_DEFAULT='\[\e[0m\]'
COLOR_RED='\[\e[38;5;1m\]'    # Красный
COLOR_RED_LIGHT='\[\e[38;5;9m\]'    # Красный
COLOR_GREEN='\[\e[38;5;2m\]'   # Салатовый
COLOR_GREEN_LIGHT='\[\e[38;5;10m\]'   # Салатовый
COLOR_YELLOW='\[\e[38;5;3m\]'   # Бирюзовый
COLOR_YELLOW_LIGHT='\[\e[38;5;11m\]'   # Бирюзовый
COLOR_BLUE='\[\e[38;5;4m\]'   # Бирюзовый
COLOR_BLUE_LIGHT='\[\e[38;5;12m\]'   # Бирюзовый
COLOR_MAGENTA='\[\e[38;5;5m\]'   # Фиолетовый
COLOR_MAGENTA_LIGHT='\[\e[38;5;13m\]'   # Фиолетовый
COLOR_CYAN='\[\e[38;5;6m\]'   # Бирюзовый
COLOR_CYAN_LIGHT='\[\e[38;5;14m\]'   # Бирюзовый
DIM='\[\e[2m\]'

# Вес шрифта
BOLD='\[\e[1m\]'
NORMAL='\[\e[22m\]'  # Сброс только жирности (сохраняя цвет)
RESET='\[\e[0m\]'   # Полный сброс (и цвет, и жирность)

# 2. Настройка текущей темы
MAIN_COLOR=${COLOR_GREEN}
SECOND_COLOR=${COLOR_DEFAULT}

# 3. Элементы конструктора
sqrBrOpen="["
username="\u"
atSymbol="@"
pcName="\h"
twoDots=":"
space=" "
relPath="\w"
sqrBrClose="]"
dollarSymbol="\$"
exitStatus="%(?.\[\e[32m\]✔.\[\e[31m\]✘)"
jobCount="[\j]"
timeShort="\t"
shSymbol="☵"

# 4. Применение PS1
case ${TERM} in
    xterm*|rxvt*|alacritty*|gnome*|konsole*|linux)
        export PS1="${BOLD}${COLOR_MAGENTA_LIGHT}${sqrBrOpen}${COLOR_GREEN_LIGHT}${username}${COLOR_BLUE_LIGHT}${atSymbol}${COLOR_RED_LIGHT}${pcName}${twoDots} ${SECOND_COLOR}${DIM}${relPath}${RESET}${BOLD}${COLOR_MAGENTA_LIGHT}${sqrBrClose}${shSymbol}${SECOND_COLOR} "
        ;;
    *)
        export PS1="[\u@\h: \w]\$ "
        ;;
esac

# 5. Полезные дополнения (Цвета в выводе команд)
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
fi

# Запуск графических программ от root
xhost +local:root > /dev/null 2>&1

# Настройка для обновления размера окна
shopt -s checkwinsize

# Настройка для работы алиасов в подоболочках и подпрограммах
shopt -s expand_aliases

# Настройка для истории команд
shopt -s histappend
