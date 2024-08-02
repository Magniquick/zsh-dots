#!/bin/zsh
# Based on https://github.com/romkatv/zsh-bench/blob/master/configs/diy%2B%2Bfsyh/skel/.zshrc, with additional modifications.

# make paths unique
# see: https://stackoverflow.com/a/68631155
typeset -U PATH FPATH path fpath

# enviorment setup of XDG stuff and $PATH, includes loading zsh plugins
source $ZDOTDIR/env.zsh
# random functions
source $ZDOTDIR/functions.zsh

# TRULY clear the history buffer
# alias reset="clear && clear" dosent work : (
# Auto cd ! 
setopt autocd
# interactive comments - dont you all talk to yourself ?
setopt interactivecomments
setopt histignorespace # better history. 
setopt INC_APPEND_HISTORY # autosuggestions should work better 
setopt EXTENDED_GLOB # required for the rebuild function to work, plus it's nice !

# python go brrr
# TODO: venv.
export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# https://superuser.com/a/645612
# setopt PROMPT_CR - breaks p10k, the fix still works too without this.
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

export EDITOR="nvim"
export VISUAL="$EDITOR"

# Some aliases
if (($+commands[eza])); then
	alias ls='eza --icons=auto --hyperlink'
	alias lah='eza -lah --icons=auto --hyperlink'
fi

# save your sanity a bit
# fixes https://stackoverflow.com/questions/68442817/iterm2-alt-backspace-like-linux#comment120968426_68442817 in a neat way
# set iTerm2 to use natural editing for best feels
WORDCHARS=${WORDCHARS/\/}

# Arrow keys traverses history considiring inital input buffer
# From https://unix.stackexchange.com/questions/16101/zsh-search-history-on-up-and-down-keys 
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# move around with ⌘ ← on mac
bindkey "^[[1;9C" end-of-line
bindkey "^[[1;9D" beginning-of-line

# init zoxide
_evalcache zoxide init zsh

# atuin + zsh_autosuggest = <3
if (($+commands[atuin])); then
	_evalcache atuin init zsh --disable-up-arrow
	_zsh_autosuggest_strategy_atuin_top() {
		suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only -e 0 --limit 1 --search-mode prefix)
	}
	_zsh_autosuggest_strategy_atuin_currentdir() {
		suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only -e 0 --limit 1 -c "$PWD" --search-mode prefix)
	}
	ZSH_AUTOSUGGEST_STRATEGY=(atuin_currentdir atuin_top completion)
fi

# https://hasseg.org/trash/
if (($+commands[trash])); then
	alias del="trash"
	alias rm='echo "Use del, or the full path, i.e. $(whence -p rm)" && false'
fi
