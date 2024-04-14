if [[ -e /opt/homebrew/bin/brew ]]; then
	#TODO: some sort of cache system ?
	#$(brew --prefix)/share/zsh/site-functions - would use this, but brew is too slow
	fpath=(/opt/homebrew/share/zsh/site-functions $fpath);
	#eval "$(/opt/homebrew/bin/brew shellenv)" # a bit too slow
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
	export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
	export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

	export HOMEBREW_NO_ENV_HINTS=TRUE
fi

source $ZDOTDIR/zsh_plugins.sh

function man-preview() {
	[[ $# -eq 0 ]] && >&2 echo "Usage: $0 command1 [command2 ...]" && return 1

	local page
	for page in "${(@f)"$(man -w $@)"}"; do
		command mandoc -Tpdf $page | open -f -a Preview
	done
}
compdef _man man-preview

