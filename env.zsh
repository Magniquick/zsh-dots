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

# Lets just set them here if they arent set already
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$UID}
XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
LANG=${LANG:-en_US.UTF-8}

# source the plugins next, so that p10k instant prompt kicks in
source $ZDOTDIR/zsh_plugins.zsh

autoload -Uz add-zsh-hook

typeset -g AUTO_VENV_ACTIVE=""
# Track the directory whose .venv we auto-activated so children keep it alive
typeset -g AUTO_VENV_DIR=""

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
			AUTO_VENV_DIR="$abs_pwd"
			echo "Activated virtual environment in $(pwd)"
		fi
	elif [[ -n "$VIRTUAL_ENV" ]] && [[ "$AUTO_VENV_ACTIVE" = "$VIRTUAL_ENV" ]] && (( $+functions[deactivate] )); then
		if [[ -z "$AUTO_VENV_DIR" ]] || { [[ "$abs_pwd" != "$AUTO_VENV_DIR" ]] && [[ "$abs_pwd" != "$AUTO_VENV_DIR"/* ]]; }; then
			deactivate
			AUTO_VENV_ACTIVE=""
			AUTO_VENV_DIR=""
			echo "Deactivated virtual environment"
		fi
	fi
}

add-zsh-hook chpwd chpwd_autosource_venv
