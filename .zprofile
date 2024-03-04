export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:-"$HOME/.local/state"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-"/run/user/$UID"}
export LANG=en_US.UTF-8

export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
# https://github.com/b3nj5m1n/xdg-ninja/issues/289#issuecomment-1666024202
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc