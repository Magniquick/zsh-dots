#!/usr/bin/env zsh
# For rebuilding in case of updates.

pushd $ZDOTDIR &> /dev/null || return 1

function has_cmd() {
	local opt
	for opt in "$@"; do
		(( $+commands[$opt] )) || return 1
	done
	return 0
}

function check_optional_dependencies() {
	local -a missing
	echo "Checking optional dependencies (atuin, kitty/iTerm2)..."

	if ! has_cmd pdftoppm; then
		missing+=("pdftoppm (better previews in less/fzf)")
	fi
	if ! has_cmd atuin; then
		missing+=("atuin (syncable history integration)")
	fi
	if ! has_cmd kitty && [[ "$TERM_PROGRAM" != "iTerm.app" ]] && [[ ! -e "$HOME/.iterm2/imgcat" ]]; then
		missing+=("kitty or iTerm2 for inline image previews")
	fi

	if (( ${#missing[@]} )); then
		printf 'Missing optional dependencies:\n'
		printf ' - %s\n' "${missing[@]}"
		echo "See README.md for details on installing these extras."
	else
		echo "All optional dependencies are available."
	fi
}

function zcompile-many() {
	autoload -U zrecompile
	local f
	for f in "$@"; do zrecompile -pq "$f"; done
}
function rebuild() {
	echo "starting compile"
	# Compile Powerlevel10k package
	make -sC $ZPLUGDIR/powerlevel10k pkg zwc &
	zcompile-many $ZDOTDIR/.p10k.zsh &
	zcompile-many $XDG_CACHE_HOME/p10k-instant-prompt-*.zsh &
	
	# Compile Fast Syntax Highlighting scripts
	zcompile-many $ZPLUGDIR/fast-syntax-highlighting/{fast*,.fast*,**/*.ch,**/*.zsh} &
	
	# Compile Zsh Autosuggestions scripts
	zcompile-many $ZPLUGDIR/zsh-autosuggestions/{*.zsh,src/**/*.zsh} &
	
	# fzf-tab and friends.
	zcompile-many $ZPLUGDIR/zsh-completions/{*.zsh,src/*} &
	zcompile-many $ZPLUGDIR/fzf-tab/*.zsh &
	zcompile-many $ZPLUGDIR/fzf-tab-source/{*.zsh,sources/*.zsh,functions/*.zsh} &
	
	#compinit
	zcompile-many $XDG_CACHE_HOME/zsh/^(*.(zwc|old)) &
	
	#and some more files too
	zcompile-many $ZDOTDIR/{*.zsh,.zprofile,.zshrc} &
}

check_optional_dependencies

# run updates
git pull
git submodule update --init --remote
rebuild # rebuild zsh plugins
if [[ ! -e $XDG_CONFIG_HOME/fsh/catppuccin-mocha.ini ]]; then
	curl --create-dirs -O --output-dir $XDG_CONFIG_HOME/fsh https://raw.githubusercontent.com/catppuccin/zsh-fsh/main/themes/catppuccin-mocha.ini # catppucin gang rise up !
	fast-theme XDG:catppuccin-mocha
fi
wait # wait for all background jobs to finish
popd
