#!/usr/bin/env zsh

# populate $PATH to be able to run stuff
# see: https://docs.brew.sh/FAQ#why-should-i-install-homebrew-in-the-default-location

# On linux, I no longer use homebrew, so this is commented out
# if [[ -e /opt/homebrew ]]; then
# 	HOMEBREW_PREFIX="/opt/homebrew"
# elif [[ -e /usr/local ]]; then
# 	HOMEBREW_PREFIX="/usr/local"
# elif [[ -e /home/linuxbrew/.linuxbrew ]]; then
# 	HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
# fi
# # If any of the directories exist, set $PATH and others for homebrew
# if [[ -n "$HOMEBREW_PREFIX" ]]; then
# 	fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath);
# 	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
# 	export HOMEBREW_REPOSITORY=$HOMEBREW_PREFIX;
# 	export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
# 	export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
# 	export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

# 	export HOMEBREW_NO_ENV_HINTS=TRUE
# 	export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"

# fi

# source the plugins first, so that p10k instant prompt kicks in
source $ZDOTDIR/zsh_plugins.zsh

autoload -Uz add-zsh-hook

typeset -g AUTO_VENV_ACTIVE=""

chpwd_autosource_venv() {
	local abs_pwd="${PWD:A}"
	local venv_dir=""

	if [[ -d .venv ]]; then
		venv_dir="$abs_pwd/.venv"
	fi

	if [[ -n "$venv_dir" ]]; then
		if [[ "$VIRTUAL_ENV" != "$venv_dir" ]]; then
			if [[ -n "$VIRTUAL_ENV" ]] && (( $+functions[deactivate] )); then
				deactivate
			fi
			source "$venv_dir/bin/activate"
			AUTO_VENV_ACTIVE="$VIRTUAL_ENV"
			echo "Activated virtual environment in $(pwd)"
		fi
	elif [[ -n "$VIRTUAL_ENV" ]] && [[ "$AUTO_VENV_ACTIVE" = "$VIRTUAL_ENV" ]] && (( $+functions[deactivate] )); then
		deactivate
		AUTO_VENV_ACTIVE=""
		echo "Deactivated virtual environment"
	fi
}

add-zsh-hook chpwd chpwd_autosource_venv
