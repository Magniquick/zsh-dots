#!/bin/zsh
# Based on https://github.com/romkatv/zsh-bench/blob/master/configs/diy%2B%2Bfsyh/skel/.zshrc, with additional modifications.

# make paths unique
# see: https://stackoverflow.com/a/68631155
typeset -U path PATH

# add homebrew completions
if [[ -e /opt/homebrew/bin/brew ]]; then
  #$(brew --prefix)/share/zsh/site-functions - would use this, but brew is too slow
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath);
  #eval "$(/opt/homebrew/bin/brew shellenv)" # a bit too slow
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

  export HOMEBREW_NO_ENV_HINTS=TRUE
fi

source $ZDOTDIR/zsh_plugins.sh

# TRULY clear the history buffer
# alias reset="clear && clear" dosent work : (
# Auto cd ! 
setopt autocd
# interactive comments - dont you all talk to yourself ?
setopt interactivecomments
setopt histignorespace # better history. 
setopt EXTENDED_GLOB # required for the rebuild function to work
# python go brrr
export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"

# https://superuser.com/a/645612
# setopt PROMPT_CR - breaks p10k, the fix still works too without this.
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

# make mysql actually usable
alias mysql-start='mysqld_safe && echo mysql has been started '
mysql-connect() {
  if  ! mysqladmin -u root ping -h localhost --silent; then
    echo "Seems like MySQL is not up, starting it...."
    (mysqld_safe 1> /dev/null &)
    while ! mysqladmin -u root ping -h localhost --silent 1> /dev/null
    do
        sleep 0.5 # at 0.1, it takes 3 iterations. 0.5 seems like a sane number to me.
        echo "Waiting for MySQL to start..."
    done
  fi
  #clear
  mysql -u root

}
alias mysql-stop='mysqladmin -u root shutdown && echo mysql has been stopped' 

alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

if [[ "$(uname -s)" = Darwin ]]; then
  function man-preview() {
    [[ $# -eq 0 ]] && >&2 echo "Usage: $0 command1 [command2 ...]" && return 1

    local page
    for page in "${(@f)"$(man -w $@)"}"; do
      command mandoc -Tpdf $page | open -f -a Preview
    done
  }
  compdef _man man-preview
fi

export EDITOR="code -w"
export VISUAL="$EDITOR"

# Some aliases
alias ls='eza --icons=auto --hyperlink'
alias lah='eza -lah --icons=auto --hyperlink'

# save your sanity a bit
# fixes https://stackoverflow.com/questions/68442817/iterm2-alt-backspace-like-linux#comment120968426_68442817 in a neat way
# set iTerm2 to use natural editing for best feels
WORDCHARS=${WORDCHARS/\/}

# Arrow keys traverses history considiring inital input buffer
# From https://unix.stackexchange.com/questions/16101/zsh-search-history-on-up-and-down-keys 
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# atuin + zsh_autosuggest = <3
if command -v atuin &> /dev/null; then
	#eval "$(atuin init zsh --disable-up-arrow)"
  source  $ZDOTDIR/init_atuin.zsh
	_zsh_autosuggest_strategy_atuin_top() {
	    suggestion=$(atuin search --cmd-only -e 0 --limit 1 --search-mode prefix -- "$1")
	}
	_zsh_autosuggest_strategy_atuin_currentdir() {
		    suggestion=$(atuin search --cmd-only -e 0 --limit 1 -c $PWD --search-mode prefix -- "$1")
		}
	ZSH_AUTOSUGGEST_STRATEGY=(atuin_currentdir atuin_top completion)
fi

alias del="trash" 
alias rm="echo Use 'del', or the full path i.e. '/bin/rm'"

topgrade() {
  command topgrade "$@" && rebuild # rebuilds zsh plugins after being pulled from github.
}

# Created by `pipx` on 2023-12-13 16:49:03 (I should've done this a while ago anyways :P)
export PATH="$HOME/.local/bin:$PATH"export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"
