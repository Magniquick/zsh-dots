#!/usr/bin/env zsh

#!/bin/bash

BUS="/run/user/1000/bus"

# First, check DBus accessibility
if [ -S "$BUS" ] && gdbus call --session \
		--dest org.freedesktop.DBus \
		--object-path / \
		--method org.freedesktop.DBus.GetId >/dev/null 2>&1; then
	echo "DBus reachable — proceeding with uwsm"
	
	if uwsm check may-start; then
		uwsm start hyprland.desktop
	else
		echo "uwsm check failed; not starting Hyprland"
	fi

else # we are in a sandbox or DBus is otherwise unreachable
	:
fi

set -a 
for f in $HOME/.config/environment.d/*.conf; do
	[ -r "$f" ] || continue; source "$f"
done
set +a