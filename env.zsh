#!/bin/zsh

# populate $PATH to be able to run stuff
# see: https://docs.brew.sh/FAQ#why-should-i-install-homebrew-in-the-default-location
if [[ -e /opt/homebrew ]]; then
	HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -e /usr/local  ]]; then
	HOMEBREW_PREFIX="/usr/local"
elif [[ -e /home/linuxbrew/.linuxbrew ]]; then
	HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi
# If any of the directories exist, set $PATH and others for homebrew
if [[ -n "$HOMEBREW_PREFIX" ]]; then
	fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath);
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
	export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
	export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

	export HOMEBREW_NO_ENV_HINTS=TRUE
fi

# source the plugins first, so that p10k instant prompt kicks in
source $ZDOTDIR/zsh_plugins.zsh

# XDG
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# https://github.com/b3nj5m1n/xdg-ninja/issues/289#issuecomment-1666024202
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export CARGO_HOME="$XDG_DATA_HOME"/cargo
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# Others
# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :