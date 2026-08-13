#!/usr/bin/env zsh

# ─────────────────────────────────────────────────────────────
# core
# ─────────────────────────────────────────────────────────────
# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────────────────────
# tools
# ─────────────────────────────────────────────────────────────
# homebrew
if [[ -d "/opt/homebrew/bin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/bin" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# development tools
export GH_TELEMETRY=false

export MISE_DATA_DIR="$XDG_DATA_HOME/mise"

export BUN_INSTALL="$HOME"/.bun

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

export GOPATH="$XDG_DATA_HOME"/go

export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm

export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history

export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var

# ─────────────────────────────────────────────────────────────
# misc.
# ─────────────────────────────────────────────────────────────
export DO_NOT_TRACK=true

export HISTFILE="$XDG_STATE_HOME"/zsh/history
