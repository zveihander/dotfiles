#!/usr/bin/env zsh

# ─────────────────────────────────────────────────────────────
# homebrew
# ─────────────────────────────────────────────────────────────
if [[ -d "/opt/homebrew/bin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/bin" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ─────────────────────────────────────────────────────────────
# options
# ─────────────────────────────────────────────────────────────
setopt AUTO_CD                 # type a dir name to cd in
setopt AUTO_PUSHD              # cd pushes onto the stack
setopt PUSHD_IGNORE_DUPS       # no duplicate dirs in stack
setopt PUSHD_SILENT            # dont print stack after pushd and popd
setopt INTERACTIVE_COMMENTS    # allow comments in interactive shell
setopt EXTENDED_GLOB           # better globbing
setopt NO_CASE_GLOB            # case insensitive globbing
setopt NUMERIC_GLOB_SORT       # sort filenames numerically
setopt AUTO_LIST               # list completion choices
setopt AUTO_MENU               # tab cycles through completion
setopt COMPLETE_IN_WORD        # complete from cursor position
setopt ALWAYS_TO_END           # cursor to end after completion
setopt NO_BEEP                 # no annoying ass beep

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY        # save timestamps
setopt HIST_EXPIRE_DUPS_FIRST  # trim dupes
setopt HIST_IGNORE_DUPS        # ignore dupes
setopt HIST_IGNORE_ALL_DUPS    # remove older dupes
setopt HIST_FIND_NO_DUPS       # skip dupes during search
setopt HIST_IGNORE_SPACE       # dont record commands if they start with space
setopt HIST_SAVE_NO_DUPS       # dont even allow it to write dupes
setopt HIST_VERIFY             # expand history refs before run
setopt SHARE_HISTORY           # share history with other sessions
setopt APPEND_HISTORY          # append to history instead of overwriting

# ─────────────────────────────────────────────────────────────
# completion
# ─────────────────────────────────────────────────────────────
autoload -Uz compinit

# only regenerate completion dump once a day for muh startup speed
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zmodload zsh/complist
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' # case insensitive, then partial-word, then substring
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true        # complete '.' and '..' too
zstyle ':completion:*' squeeze-slashes false    # don't collapse // in paths
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'

# cache (speed!!!)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache

# homebrew completions
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

# bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# ─────────────────────────────────────────────────────────────
# keybinds
# ─────────────────────────────────────────────────────────────
bindkey -e                              # emacs > vim !
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word          # ctrl+right
bindkey '^[[1;5D' backward-word         # ctrl+left
bindkey '^[[3~'  delete-char            # fn+delete / delete key
bindkey '^U' backward-kill-line
bindkey '^ ' autosuggest-accept         # ctrl+space

# ─────────────────────────────────────────────────────────────
# plugins
# ─────────────────────────────────────────────────────────────
# homebrew
BREW_PREFIX="$(brew --prefix 2>/dev/null)"

[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ─────────────────────────────────────────────────────────────
# prompt
# ─────────────────────────────────────────────────────────────
# starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ─────────────────────────────────────────────────────────────
# navigation
# ─────────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
  source <(fzf --zsh) 2>/dev/null || true
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ─────────────────────────────────────────────────────────────
# aliases && replacements
# ─────────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first --ignore-glob "node_modules|.git"'
  alias ll='eza -lah --icons --group-directories-first --ignore-glob "node_modules|.git"'
  alias lt='eza --tree --level=2 --icons --ignore-glob "node_modules|.git"'
else
  alias ll='ls -lah'
fi

command -v bat &>/dev/null && alias cat='bat --paging=never --style=plain'
command -v rg  &>/dev/null && alias grep='rg'
command -v fd  &>/dev/null && alias find='fd'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'
alias path='echo $PATH | tr ":" "\n"'
alias ip='ipconfig getifaddr en0'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

alias brewup='brew update && brew upgrade && brew cleanup'

# git
command -v lazygit &>/dev/null && alias lg='lazygit'

# colorized help
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain --pager=never'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain --pager=never'

# colorized coreutils
if command -v bat &>/dev/null; then
  diff() {
    if [[ -t 1 ]]; then command diff --color=never "$@" | bat --pager=never -l diff
    else command diff "$@"; fi
  }
  ps() {
    if [[ -t 1 ]]; then command ps "$@" | bat --pager=never --style=plain -l conf
    else command ps "$@"; fi
  }
  df() {
    if [[ -t 1 ]]; then command df -h "$@" | bat --pager=never --style=plain -l conf
    else command df "$@"; fi
  }
  du() {
    if [[ -t 1 ]]; then command du -h -d 1 "$@" | bat --pager=never --style=plain
    else command du "$@"; fi
  }
fi

# ─────────────────────────────────────────────────────────────
# misc. env
# ─────────────────────────────────────────────────────────────
export EDITOR="zed -w"
export VISUAL="$EDITOR"
export LESS='-R'
export LANG='en_US.UTF-8'

# colorized manpages
export MANROFFOPT='-c'
export MANPAGER="sh -c \"col -bx | bat --language=man --style=grid --color=always --paging=always\""

# ─────────────────────────────────────────────────────────────
# tools
# ─────────────────────────────────────────────────────────────
# mise
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
