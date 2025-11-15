#!/usr/bin/env zsh

if uwsm check may-start; then
	uwsm start hyprland.desktop
fi

set -a 
for f in $HOME/.config/environment.d/*.conf; do
	[ -r "$f" ] || continue; source "$f"
done
set +a