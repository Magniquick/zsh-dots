#!/usr/bin/env zsh
# For rebuilding in case of updates.

# Check if XDG_CONFIG_HOME is set
if [ -z "$XDG_CONFIG_HOME" ]; then
	echo "XDG_CONFIG_HOME is not set. Setting up enviorment.d file..."
	mkdir -p "$HOME/.config/environment.d"
	curl -o "$HOME/.config/environment.d/xdg.conf" https://raw.githubusercontent.com/Magniquick/dotfiles/refs/heads/main/dot_config/environment.d/xdg.conf

	echo "File downloaded to $HOME/.config/environment.d/xdg.conf"
	exec zsh
fi

pushd $ZDOTDIR &> /dev/null || return 1
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
	zcompile-many $ZDOTDIR/zsh_plugins.zsh &
}
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
