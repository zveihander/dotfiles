# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Env vars
export TERMINAL="ghostty -e"
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# Tab completion-ish
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

alias ls='ls --color=auto'
export PS1="[\u@\[$(tput bold)\]\[$(tput setaf 7)\]\h\[$(tput sgr0)\]\[$(tput setaf 2)\] \W\[$(tput sgr0)\]]\[$(tput sgr0)\] "
. "$HOME/.cargo/env"

countdown() {
    start="$(( $(date '+%s') + $1))"
    while [ $start -ge $(date +%s) ]; do
        time="$(( $start - $(date +%s) ))"
        printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.1
    done
}

stopwatch() {
    start=$(date +%s)
    while true; do
        time="$(( $(date +%s) - $start))"
        printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.1
    done
}

# bash-completion
complete -F _command doas

# Created by `pipx` on 2025-12-17 04:33:33
export PATH="$PATH:/home/evan/dotfiles/.local/bin"
