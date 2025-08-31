#!/usr/bin/env zsh
set -a 
for f in $HOME/.config/environment.d/*.conf; do
	[ -r "$f" ] || continue; source "$f"
done
set +a