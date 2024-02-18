export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:-"$HOME/.local/state"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-"/run/user/$UID"}
LESSHISTFILE="$XDG_STATE_HOME"/less/history
export LANG=en_US.UTF-8
