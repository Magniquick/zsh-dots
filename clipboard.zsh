#!/usr/bin/env zsh
# Clipboard helpers — self-contained replacement for the old zpm-zsh/clipboard
# submodule. Provides `pbcopy`, `pbpaste`, `open`, and an enhanced `clip`.

# pbcopy: write stdin to the system clipboard
pbcopy() {
	if (( ${+commands[wl-copy]} )); then
		wl-copy
	elif (( ${+commands[xclip]} )); then
		xclip -selection clipboard -in
	elif (( ${+commands[xsel]} )); then
		xsel -b -i
	elif (( ${+commands[termux-clipboard-set]} )); then
		termux-clipboard-set
	elif [[ $OSTYPE == linux* && -r /proc/version && "$(< /proc/version)" == *[Mm]icrosoft* ]]; then
		clip.exe # WSL 1 or 2
	elif [[ $OSTYPE == darwin* ]]; then
		command pbcopy
	elif [[ $OSTYPE == (cygwin*|msys) ]]; then
		tee > /dev/clipboard
	else
		print -u2 "pbcopy: no clipboard backend found (install wl-clipboard, xclip, or xsel)"
		return 1
	fi
}

# pbpaste: read the system clipboard to stdout
pbpaste() {
	if (( ${+commands[wl-paste]} )); then
		wl-paste
	elif (( ${+commands[xclip]} )); then
		xclip -selection clipboard -out
	elif (( ${+commands[xsel]} )); then
		xsel -b -o
	elif (( ${+commands[termux-clipboard-get]} )); then
		termux-clipboard-get
	elif [[ $OSTYPE == linux* && -r /proc/version && "$(< /proc/version)" == *[Mm]icrosoft* ]]; then
		powershell.exe -NoProfile -NonInteractive -Command Get-Clipboard # WSL 1 or 2
	elif [[ $OSTYPE == darwin* ]]; then
		command pbpaste
	elif [[ $OSTYPE == (cygwin*|msys) ]]; then
		print "$(< /dev/clipboard)"
	else
		print -u2 "pbpaste: no clipboard backend found (install wl-clipboard, xclip, or xsel)"
		return 1
	fi
}

# open: cross-platform file/URL opener
open() {
	if (( ${+commands[xdg-open]} )); then
		command xdg-open "$@"
	elif (( ${+commands[termux-open]} )); then
		termux-open "$@"
	elif [[ $OSTYPE == darwin* ]]; then
		command open "$@"
	elif [[ $OSTYPE == cygwin* ]]; then
		if (( ${+commands[cygstart]} )); then
			cygstart "$@"
		else
			start "$@"
		fi
	elif [[ $OSTYPE == linux* && -r /proc/version && "$(< /proc/version)" == *[Mm]icrosoft* ]]; then
		explorer.exe "$@" # WSL 1 or 2
	elif [[ $OSTYPE == msys ]]; then
		explorer.exe "$(cygpath -w "$@")"
	fi
}

# clip: clipboard swiss-army knife
#   clip <file>     copy a file to the clipboard (images copied as image/*, else as text)
#   command | clip  copy stdin to the clipboard
#   clip            paste the clipboard to stdout
clip() {
	if (( $# )); then
		# file argument → copy its contents
		local f=$1
		if [[ ! -r $f ]]; then
			print -u2 "clip: cannot read '$f'"
			return 1
		fi
		local mime
		mime=$(file -b --mime-type -- "$f" 2>/dev/null) || mime=application/octet-stream
		if [[ $mime == image/* ]] && (( ${+commands[wl-copy]} )); then
			wl-copy --type "$mime" < "$f"
		elif [[ $mime == image/* ]] && (( ${+commands[xclip]} )); then
			xclip -selection clipboard -t "$mime" -in < "$f"
		else
			pbcopy < "$f"
		fi
	elif [[ -t 0 ]]; then
		# no args, interactive → paste
		pbpaste
	else
		# stdin is a pipe → copy
		pbcopy
	fi
}
