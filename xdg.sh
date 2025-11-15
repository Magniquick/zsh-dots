#!/usr/bin/env zsh 
# shellcheck disable=SC1071

# Android
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android

adb() {
    HOME="$XDG_DATA_HOME/android" command adb "$@"
}

# Rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
# GNUPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# Go
GOPATH="$XDG_DATA_HOME"/go
# Mypy
export MYPY_CACHE_DIR="$XDG_CACHE_HOME"/mypy
# npm
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js   
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm                             
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm   
# wget
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
# Python
export PYTHON_HISTORY="$HOME"/.local/state/python_history
# less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
# dotnet - strike 1
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export CODEX_HOME="$XDG_DATA_HOME"/codex