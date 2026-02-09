#!/usr/bin/env zsh

set -a
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" ]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
fi
. /dev/fd/0 <<EOF
$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
EOF
set +a

if uwsm check may-start > /dev/null; then
	exec uwsm start hyprland.desktop > /dev/null # redirect success messages to the void
fi
