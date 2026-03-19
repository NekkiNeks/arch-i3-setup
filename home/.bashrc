
### CUSTOM PATH VARIABLES ###
export PATH="$PATH:$HOME/.local/bin/"       # Папка .bin для хранения Appimage файлов
#############################

 
### OTHER VARIABLES ###
export EDITOR=nvim                          # Основной редактор текста
export SYSTEMD_EDITOR=nvim                  # Редактор текста для systemd и systemctl
########################

### GOLANG VARIABLES ###
export GOPATH=$HOME/.local/share/go         # Устанавливаем новый путь для рабочей области
export GOMODCACHE=$HOME/.cache/go-build/    # Кэш golang
export PATH=$PATH:$GOPATH/bin               # чтобы установленные через 'go install' утилиты были доступны в терминале
export PATH=$PATH:/usr/local/go/bin         # Путь к основному бинарнику go
#########################

### NVM VARIABLES ###
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#####################


### ANDROID STUDIO VARIABLES ###
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
################################

### RUST VARIABLES ###
source "$HOME/.cargo/env" # Подключение sh файла с переменными
######################

### ALIASES ###
alias gosleep='systemctl suspend'
#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less
###############


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

colors() {
    local fgc bgc vals seq0
    local sem=";"
    local esc="\e["
    local reset="\e[m"

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    for fgc in {30..37}; do
        for bgc in {40..47}; do
            local cur_fg=${fgc#37}
            local cur_bg=${bgc#40}

            if [[ -n $cur_fg ]]; then
                vals="${cur_fg}${sem}${cur_bg}"
            else
                vals="${cur_bg}"
            fi
            vals=${vals%%$sem}

            if [[ -n $vals ]]; then
                seq0="${esc}${vals}m"
            else
                seq0=""
            fi

            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT${reset}"
            
            local bold_vals="$vals"
            [[ -n $vals ]] && bold_vals="${vals}${sem}"
            printf " \e[${bold_vals}1mBOLD${reset}"
        done
        echo; echo
    done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac

use_color=true
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
    if type -P dircolors >/dev/null ; then
        if [[ -f ~/.dir_colors ]] ; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]] ; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi

    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\e[01;91m\][\h\[\e[01;36m\] \W\[\e[01;91m\]]\$\[\e[00m\] '
    else
        PS1='\[\e[01;91m\][\u@\h\[\e[01;37m\] \W\[\e[01;91m\]]\$\[\e[00m\] '
    fi

    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
else
    if [[ ${EUID} == 0 ]] ; then
        PS1='\u@\h \W \$ '
    else
        PS1='\u@\h \w \$ '
    fi
fi

unset use_color safe_term match_lhs sh


xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend



