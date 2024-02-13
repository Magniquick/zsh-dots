function zcompile-many() {
  autoload -U zrecompile
  local f
  for f; do zrecompile -pq "$f"; done
}

# For rebuildiing in case of updates.
function rebuild() {
	echo "starting compile"
	# Compile Powerlevel10k package
	make -sC $ZDOTDIR/plugins/powerlevel10k pkg zwc &
  zcompile-many $ZDOTDIR/.p10k.zsh &
  zcompile-many ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-*.zsh &

  # Move and compile Fast Syntax Highlighting scripts
	(mv -- $ZDOTDIR/plugins/fast-syntax-highlighting/{'→chroma','tmp'} && zcompile-many $ZDOTDIR/plugins/fast-syntax-highlighting/{fast*,.fast*,**/*.ch,**/*.zsh} && mv -- $ZDOTDIR/plugins/fast-syntax-highlighting/{'tmp','→chroma'}) &
	
	# Compile Zsh Autosuggestions scripts
	zcompile-many $ZDOTDIR/plugins/zsh-autosuggestions/{*.zsh,src/**/*.zsh} &

  # fzf-tab and friends. 
  zcompile-many $ZDOTDIR/plugins/zsh-completions/{*.zsh,src/*} &
  zcompile-many $ZDOTDIR/plugins/fzf-tab/*.zsh &
  zcompile-many $ZDOTDIR/plugins/fzf-tab-source/{*.zsh,sources/*.zsh,functions/*.zsh} &
  zcompile-many $ZDOTDIR/init_atuin.zsh &

  #compinit
  zcompile-many ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/^(*(D).(zwc|old)) &
  wait
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e $ZDOTDIR/plugins/fast-syntax-highlighting ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZDOTDIR/plugins/fast-syntax-highlighting
  curl --create-dirs -O --output-dir ${XDG_CONFIG_HOME:-$HOME/.config}/fsh https://raw.githubusercontent.com/catppuccin/zsh-fsh/main/themes/catppuccin-macchiato.ini # catppucin gang rise up !
  fast-theme XDG:catppuccin-macchiato
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/zsh-autosuggestions ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/zsh-users/zsh-autosuggestions.git $ZDOTDIR/plugins/zsh-autosuggestions
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/powerlevel10k ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/romkatv/powerlevel10k.git $ZDOTDIR/plugins/powerlevel10k
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/fzf-tab ]]; then
  git clone --depth=1  --recursive --shallow-submodules -b complete-common-prefix --single-branch https://github.com/jochenwierum/fzf-tab.git $ZDOTDIR/plugins/fzf-tab # uses a fork for auto prefix matching
  # git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git $ZDOTDIR/plugins/fzf-tab # orginal
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/fzf-tab-source ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/Freed-Wu/fzf-tab-source.git $ZDOTDIR/plugins/fzf-tab-source
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/zsh-completions ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/zsh-users/zsh-completions.git $ZDOTDIR/plugins/zsh-completions
  requires_rebuild=True
fi
if [[ ! -e $ZDOTDIR/plugins/iterm2 ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/gnachman/iTerm2-shell-integration.git $ZDOTDIR/plugins/iterm2
fi


if ! type fzf &>/dev/null; then
  echo 'Warning: fzf is requried for the bundled fzf-tab plugin but was not found.'
  echo 'Please install it.'
fi

if (( ${+requires_rebuild} )); then
	rebuild
fi

# Activate Powerlevel10k Instant Prompt.
# Try to move all possible commands below this (make sure there is no output by the commands).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load plugins.
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh
source $ZDOTDIR/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh
export LESSOPEN="|$ZDOTDIR/lessfilter %s"
zstyle ':fzf-tab:*' fzf-min-height 70
zstyle ':completion:complete:*:argument-rest' sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'  # case insensitive file matching
setopt globdots
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

if [[ $TERM_PROGRAM = "iTerm.app" ]]; then
  source "$ZDOTDIR/plugins/iterm2/shell_integration/zsh"
fi

# Enable the "new" completion system (compsys).
# Add plugins that change fpath above this - I nearly lost my sanity over this :/ 
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/"
autoload -Uz compinit && compinit -ud ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/.zcompdump

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme