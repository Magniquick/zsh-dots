#!/usr/bin/env zsh

# Based on https://github.com/romkatv/zsh-bench/blob/master/configs/diy%2B%2Bfsyh/skel/.zshrc, with additional modifications.

# make paths unique
# see: https://stackoverflow.com/a/68631155
typeset -U PATH FPATH path fpath

# https://unix.stackexchange.com/a/12108
stty -ixon

# enviorment setup of XDG stuff and $PATH, includes loading zsh plugins
source $ZDOTDIR/env.zsh
source $ZDOTDIR/xdg.zsh
# random stuff
source $ZDOTDIR/random.zsh

# Auto cd !
setopt autocd
# interactive comments - dont you all talk to yourself ?
setopt interactivecomments
setopt histignorespace # better history.
setopt INC_APPEND_HISTORY # autosuggestions should work better
setopt EXTENDED_GLOB # required for the rebuild function to work, plus it's nice !
# History
export HISTFILE="$ZDOTDIR/.histfile"
export SAVEHIST=300000
export HISTSIZE=$SAVEHIST
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

# add custom bin dir and local bin (for uv) to path
export PATH="$HOME/.local/bin/custom:$HOME/.local/bin:$PATH"

# https://superuser.com/a/645612
# setopt PROMPT_CR - breaks p10k, the fix still works too without this.
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

# Set preferred editor
for editor in micro nano vim vi; do
	if (($+commands[$editor])); then
		export EDITOR="$editor"
		break
	fi
done
for visual in "code --wait" "subl" "vim" "nano"; do
  	cmd=${visual%% *}
	if (($+commands[$cmd])); then
		export VISUAL="$visual"
		break
	fi
done


# Some aliases
if (($+commands[eza])); then
	alias ls='eza --icons=auto --hyperlink'
	alias lah='eza -lah --icons=auto --hyperlink'
	alias tree='eza --icons=auto --hyperlink --tree'
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
bindkey "^[[1;9D" beginning-of-line
bindkey "^[[1;9C" end-of-line
# and home and end too
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# Move cursor to the very beginning of the buffer
zle_to_buffer_start() { CURSOR=0 }
zle -N buffer-start zle_to_buffer_start

# Move cursor to the very end of the buffer
zle_to_buffer_end() { CURSOR=${#BUFFER} }
zle -N buffer-end zle_to_buffer_end

# and page up and down
bindkey '^[[5~' buffer-start  # PageUp
bindkey '^[[6~' buffer-end    # PageDown
# and on linux (maybe windows too ?)
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^H" backward-delete-word
bindkey "^[[3;5~" kill-word
bindkey "^[[3;3~" kill-word
bindkey "^[[3~" delete-char

# init zoxide
smartcache eval zoxide init zsh

# atuin + zsh_autosuggest = <3
if (($+commands[atuin])); then
	smartcache eval atuin init zsh --disable-up-arrow
	_zsh_autosuggest_strategy_atuin_dir() {
		suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only -e 0 --limit 1 --search-mode prefix -c "$PWD" 2> /dev/null)
	}
	_zsh_autosuggest_strategy_atuin_top() {
		suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only -e 0 --limit 1 --search-mode prefix 2> /dev/null)
	}
	ZSH_AUTOSUGGEST_STRATEGY=(atuin_dir atuin_top completion)
fi

if (($+commands[gio])); then
	export TRASH_CMD="gio trash"
elif (($+commands[gtrash])); then
	export TRASH_CMD="gtrash put"
elif (($+commands[trash])); then
	export TRASH_CMD="trash"
elif (($+commands[trash-put])); then
	export TRASH_CMD="trash-put"
fi

if [[ -n "$TRASH_CMD" ]]; then
	alias del="$TRASH_CMD"
	alias rm='echo "Use del, or the full path, i.e. $(whence -p rm)" && false'
fi
