#!/usr/bin/env zsh

if uwsm check may-start; then
	exec uwsm start hyprland.desktop > /dev/null # redirect success messages to the void
fi

set -a 
for f in $HOME/.config/environment.d/*.conf; do
	[ -r "$f" ] || continue; source "$f"
done
set +a
