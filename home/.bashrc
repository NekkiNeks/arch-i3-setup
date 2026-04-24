
### CUSTOM PATH VARIABLES ###
export PATH="$PATH:$HOME/.local/bin/"       # Папка .bin для хранения Appimage файлов

### OTHER VARIABLES ###
export EDITOR=nvim                          # Основной редактор текста
export SYSTEMD_EDITOR=nvim                  # Редактор текста для systemd и systemctl

### GOLANG VARIABLES ###
export GOPATH=$HOME/.local/share/go         # Устанавливаем новый путь для рабочей области
export GOMODCACHE=$HOME/.cache/go-build/    # Кэш golang
export PATH=$PATH:$GOPATH/bin               # чтобы установленные через 'go install' утилиты были доступны в терминале
export PATH=$PATH:/usr/local/go/bin         # Путь к основному бинарнику go

### NVM VARIABLES ###
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


### ANDROID STUDIO VARIABLES ###
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

### RUST VARIABLES ###
source "$HOME/.cargo/env" # Подключение sh файла с переменными

### ALIASES ###
alias gosleep='systemctl suspend'
alias al='alacritty --working-directory "$PWD" &'
alias alac='alacritty --working-directory "$PWD" &'
alias ar='alacritty --working-directory "$PWD" -e bash -c "ranger; exec bash" &'
#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less

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
COLOR_GREEN='\[\e[38;5;10m\]'   # Салатовый
COLOR_CYAN='\[\e[38;5;6m\]'   # Бирюзовый
COLOR_RED='\[\e[38;5;1m\]'    # Красный
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
        export PS1="${BOLD}${MAIN_COLOR}${sqrBrOpen}${username}${atSymbol}${pcName}${twoDots} ${SECOND_COLOR}${DIM}${relPath}${BOLD}${MAIN_COLOR}${sqrBrClose}${shSymbol}${SECOND_COLOR} "
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



