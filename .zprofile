#!/usr/bin/env zsh

if uwsm check may-start; then
	exec uwsm start hyprland.desktop > /dev/null # redirect success messages to the void
fi

set -a 
. /dev/fd/0 <<EOF
$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
EOF
set +a
