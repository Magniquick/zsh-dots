#!/bin/zsh
function zcompile-many() {
	autoload -U zrecompile
	local f
	for f in "$@"; do zrecompile -pq "$f"; done
}

# For rebuildiing in case of updates.
function rebuild() {
	echo "starting compile"
	# Compile Powerlevel10k package
	make -sC $ZDOTDIR/plugins/powerlevel10k pkg zwc &
	zcompile-many $ZDOTDIR/.p10k.zsh &
	zcompile-many $XDG_CACHE_HOME/p10k-instant-prompt-*.zsh &

	# Move and compile Fast Syntax Highlighting scripts
	zcompile-many $ZDOTDIR/plugins/fast-syntax-highlighting/{fast*,.fast*,**/*.ch,**/*.zsh} &
	
	# Compile Zsh Autosuggestions scripts
	zcompile-many $ZDOTDIR/plugins/zsh-autosuggestions/{*.zsh,src/**/*.zsh} &

	# fzf-tab and friends. 
	zcompile-many $ZDOTDIR/plugins/zsh-completions/{*.zsh,src/*} &
	zcompile-many $ZDOTDIR/plugins/fzf-tab/*.zsh &
	zcompile-many $ZDOTDIR/plugins/fzf-tab-source/{*.zsh,sources/*.zsh,functions/*.zsh} &
	zcompile-many $ZDOTDIR/init_atuin.zsh &

	#compinit
	zcompile-many $XDG_CACHE_HOME/zsh/^(*.(zwc|old)) &

	#and some more files too
	zcompile-many $ZDOTDIR/zsh_plugins.sh &
	wait
}

# Clone and compile to wordcode missing plugins.
plug() {
    # Extract the repository name from the URL
	# The ${1:t} extracts the tail of the URL, which is typically the part after the last / (i.e., repo.git).
	# The ${:r} removes the file extension, leaving the repository name (i.e., repo).
    local repo_name="${1:t:r}"
    # Clone the repository into the home directory under a directory named after the repo
    git clone --depth=1 "$1" "$ZDOTDIR"/plugins/"$repo_name"
	# Set the rebuild flag
	requires_rebuild=True
}

if [[ ! -e $ZDOTDIR/plugins/fast-syntax-highlighting ]]; then
	plug https://github.com/zdharma-continuum/fast-syntax-highlighting.git
	curl --create-dirs -O --output-dir ${XDG_CONFIG_HOME}/fsh https://raw.githubusercontent.com/catppuccin/zsh-fsh/main/themes/catppuccin-mocha.ini # catppucin gang rise up !
	source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh # TODO: avoid sourcing twice
	fast-theme XDG:catppuccin-mocha
fi
if [[ ! -e $ZDOTDIR/plugins/zsh-autosuggestions ]]; then
	plug https://github.com/zsh-users/zsh-autosuggestions.git
fi
if [[ ! -e $ZDOTDIR/plugins/powerlevel10k ]]; then
	plug https://github.com/romkatv/powerlevel10k.git
fi
if [[ ! -e $ZDOTDIR/plugins/fzf-tab ]]; then
	plug https://github.com/Aloxaf/fzf-tab.git
fi
if [[ ! -e $ZDOTDIR/plugins/fzf-tab-source ]]; then
	plug https://github.com/Magniquick/fzf-tab-source.git
fi
if [[ ! -e $ZDOTDIR/plugins/zsh-completions ]]; then
	plug https://github.com/zsh-users/zsh-completions.git
fi
if [[ ! -e $ZDOTDIR/plugins/clipboard ]]; then
	plug https://github.com/zpm-zsh/clipboard.git 
fi
if [[ ! -e $ZDOTDIR/plugins/evalcache ]]; then
	plug https://github.com/mroth/evalcache.git
fi
if [[ ! -e $ZDOTDIR/plugins/iTerm2-shell-integration ]] && [[ $TERM_PROGRAM = "iTerm.app" ]]; then
	plug https://github.com/gnachman/iTerm2-shell-integration.git
fi
unfunction plug

if ((${+requires_rebuild})); then
	rebuild
fi

# Activate Powerlevel10k Instant Prompt.
# Try to move all possible commands below this (make sure there is no output by the commands).
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Generated using $(vivid generate catppuccin-mocha)
# https://github.com/sharkdp/vivid
if (($+commands[vivid])); then
	_evalcache vivid generate catppuccin-mocha
else
	export LS_COLORS="*~=0;38;2;88;91;112:bd=0;38;2;116;199;236;48;2;49;50;68:ca=0:cd=0;38;2;245;194;231;48;2;49;50;68:di=0;38;2;137;180;250:do=0;38;2;17;17;27;48;2;245;194;231:ex=1;38;2;243;139;168:fi=0:ln=0;38;2;245;194;231:mh=0:mi=0;38;2;17;17;27;48;2;243;139;168:no=0:or=0;38;2;17;17;27;48;2;243;139;168:ow=0:pi=0;38;2;17;17;27;48;2;137;180;250:rs=0:sg=0:so=0;38;2;17;17;27;48;2;245;194;231:st=0:su=0:tw=0:*.a=1;38;2;243;139;168:*.c=0;38;2;166;227;161:*.d=0;38;2;166;227;161:*.h=0;38;2;166;227;161:*.m=0;38;2;166;227;161:*.o=0;38;2;88;91;112:*.p=0;38;2;166;227;161:*.r=0;38;2;166;227;161:*.t=0;38;2;166;227;161:*.z=4;38;2;116;199;236:*.7z=4;38;2;116;199;236:*.as=0;38;2;166;227;161:*.bc=0;38;2;88;91;112:*.bz=4;38;2;116;199;236:*.cc=0;38;2;166;227;161:*.cp=0;38;2;166;227;161:*.cr=0;38;2;166;227;161:*.cs=0;38;2;166;227;161:*.di=0;38;2;166;227;161:*.el=0;38;2;166;227;161:*.ex=0;38;2;166;227;161:*.fs=0;38;2;166;227;161:*.go=0;38;2;166;227;161:*.gv=0;38;2;166;227;161:*.gz=4;38;2;116;199;236:*.hh=0;38;2;166;227;161:*.hi=0;38;2;88;91;112:*.hs=0;38;2;166;227;161:*.jl=0;38;2;166;227;161:*.js=0;38;2;166;227;161:*.ko=1;38;2;243;139;168:*.kt=0;38;2;166;227;161:*.la=0;38;2;88;91;112:*.ll=0;38;2;166;227;161:*.lo=0;38;2;88;91;112:*.md=0;38;2;249;226;175:*.ml=0;38;2;166;227;161:*.mn=0;38;2;166;227;161:*.nb=0;38;2;166;227;161:*.pl=0;38;2;166;227;161:*.pm=0;38;2;166;227;161:*.pp=0;38;2;166;227;161:*.ps=0;38;2;243;139;168:*.py=0;38;2;166;227;161:*.rb=0;38;2;166;227;161:*.rm=0;38;2;242;205;205:*.rs=0;38;2;166;227;161:*.sh=0;38;2;166;227;161:*.so=1;38;2;243;139;168:*.td=0;38;2;166;227;161:*.ts=0;38;2;166;227;161:*.ui=0;38;2;249;226;175:*.vb=0;38;2;166;227;161:*.wv=0;38;2;242;205;205:*.xz=4;38;2;116;199;236:*.aif=0;38;2;242;205;205:*.ape=0;38;2;242;205;205:*.apk=4;38;2;116;199;236:*.arj=4;38;2;116;199;236:*.asa=0;38;2;166;227;161:*.aux=0;38;2;88;91;112:*.avi=0;38;2;242;205;205:*.awk=0;38;2;166;227;161:*.bag=4;38;2;116;199;236:*.bak=0;38;2;88;91;112:*.bat=1;38;2;243;139;168:*.bbl=0;38;2;88;91;112:*.bcf=0;38;2;88;91;112:*.bib=0;38;2;249;226;175:*.bin=4;38;2;116;199;236:*.blg=0;38;2;88;91;112:*.bmp=0;38;2;242;205;205:*.bsh=0;38;2;166;227;161:*.bst=0;38;2;249;226;175:*.bz2=4;38;2;116;199;236:*.c++=0;38;2;166;227;161:*.cfg=0;38;2;249;226;175:*.cgi=0;38;2;166;227;161:*.clj=0;38;2;166;227;161:*.com=1;38;2;243;139;168:*.cpp=0;38;2;166;227;161:*.css=0;38;2;166;227;161:*.csv=0;38;2;249;226;175:*.csx=0;38;2;166;227;161:*.cxx=0;38;2;166;227;161:*.deb=4;38;2;116;199;236:*.def=0;38;2;166;227;161:*.dll=1;38;2;243;139;168:*.dmg=4;38;2;116;199;236:*.doc=0;38;2;243;139;168:*.dot=0;38;2;166;227;161:*.dox=0;38;2;148;226;213:*.dpr=0;38;2;166;227;161:*.elc=0;38;2;166;227;161:*.elm=0;38;2;166;227;161:*.epp=0;38;2;166;227;161:*.eps=0;38;2;242;205;205:*.erl=0;38;2;166;227;161:*.exe=1;38;2;243;139;168:*.exs=0;38;2;166;227;161:*.fls=0;38;2;88;91;112:*.flv=0;38;2;242;205;205:*.fnt=0;38;2;242;205;205:*.fon=0;38;2;242;205;205:*.fsi=0;38;2;166;227;161:*.fsx=0;38;2;166;227;161:*.gif=0;38;2;242;205;205:*.git=0;38;2;88;91;112:*.gvy=0;38;2;166;227;161:*.h++=0;38;2;166;227;161:*.hpp=0;38;2;166;227;161:*.htc=0;38;2;166;227;161:*.htm=0;38;2;249;226;175:*.hxx=0;38;2;166;227;161:*.ico=0;38;2;242;205;205:*.ics=0;38;2;243;139;168:*.idx=0;38;2;88;91;112:*.ilg=0;38;2;88;91;112:*.img=4;38;2;116;199;236:*.inc=0;38;2;166;227;161:*.ind=0;38;2;88;91;112:*.ini=0;38;2;249;226;175:*.inl=0;38;2;166;227;161:*.ipp=0;38;2;166;227;161:*.iso=4;38;2;116;199;236:*.jar=4;38;2;116;199;236:*.jpg=0;38;2;242;205;205:*.kex=0;38;2;243;139;168:*.kts=0;38;2;166;227;161:*.log=0;38;2;88;91;112:*.ltx=0;38;2;166;227;161:*.lua=0;38;2;166;227;161:*.m3u=0;38;2;242;205;205:*.m4a=0;38;2;242;205;205:*.m4v=0;38;2;242;205;205:*.mid=0;38;2;242;205;205:*.mir=0;38;2;166;227;161:*.mkv=0;38;2;242;205;205:*.mli=0;38;2;166;227;161:*.mov=0;38;2;242;205;205:*.mp3=0;38;2;242;205;205:*.mp4=0;38;2;242;205;205:*.mpg=0;38;2;242;205;205:*.nix=0;38;2;249;226;175:*.odp=0;38;2;243;139;168:*.ods=0;38;2;243;139;168:*.odt=0;38;2;243;139;168:*.ogg=0;38;2;242;205;205:*.org=0;38;2;249;226;175:*.otf=0;38;2;242;205;205:*.out=0;38;2;88;91;112:*.pas=0;38;2;166;227;161:*.pbm=0;38;2;242;205;205:*.pdf=0;38;2;243;139;168:*.pgm=0;38;2;242;205;205:*.php=0;38;2;166;227;161:*.pid=0;38;2;88;91;112:*.pkg=4;38;2;116;199;236:*.png=0;38;2;242;205;205:*.pod=0;38;2;166;227;161:*.ppm=0;38;2;242;205;205:*.pps=0;38;2;243;139;168:*.ppt=0;38;2;243;139;168:*.pro=0;38;2;148;226;213:*.ps1=0;38;2;166;227;161:*.psd=0;38;2;242;205;205:*.pyc=0;38;2;88;91;112:*.pyd=0;38;2;88;91;112:*.pyo=0;38;2;88;91;112:*.rar=4;38;2;116;199;236:*.rpm=4;38;2;116;199;236:*.rst=0;38;2;249;226;175:*.rtf=0;38;2;243;139;168:*.sbt=0;38;2;166;227;161:*.sql=0;38;2;166;227;161:*.sty=0;38;2;88;91;112:*.svg=0;38;2;242;205;205:*.swf=0;38;2;242;205;205:*.swp=0;38;2;88;91;112:*.sxi=0;38;2;243;139;168:*.sxw=0;38;2;243;139;168:*.tar=4;38;2;116;199;236:*.tbz=4;38;2;116;199;236:*.tcl=0;38;2;166;227;161:*.tex=0;38;2;166;227;161:*.tgz=4;38;2;116;199;236:*.tif=0;38;2;242;205;205:*.tml=0;38;2;249;226;175:*.tmp=0;38;2;88;91;112:*.toc=0;38;2;88;91;112:*.tsx=0;38;2;166;227;161:*.ttf=0;38;2;242;205;205:*.txt=0;38;2;249;226;175:*.vcd=4;38;2;116;199;236:*.vim=0;38;2;166;227;161:*.vob=0;38;2;242;205;205:*.wav=0;38;2;242;205;205:*.wma=0;38;2;242;205;205:*.wmv=0;38;2;242;205;205:*.xcf=0;38;2;242;205;205:*.xlr=0;38;2;243;139;168:*.xls=0;38;2;243;139;168:*.xml=0;38;2;249;226;175:*.xmp=0;38;2;249;226;175:*.yml=0;38;2;249;226;175:*.zip=4;38;2;116;199;236:*.zsh=0;38;2;166;227;161:*.zst=4;38;2;116;199;236:*TODO=1:*hgrc=0;38;2;148;226;213:*.bash=0;38;2;166;227;161:*.conf=0;38;2;249;226;175:*.dart=0;38;2;166;227;161:*.diff=0;38;2;166;227;161:*.docx=0;38;2;243;139;168:*.epub=0;38;2;243;139;168:*.fish=0;38;2;166;227;161:*.flac=0;38;2;242;205;205:*.h264=0;38;2;242;205;205:*.hgrc=0;38;2;148;226;213:*.html=0;38;2;249;226;175:*.java=0;38;2;166;227;161:*.jpeg=0;38;2;242;205;205:*.json=0;38;2;249;226;175:*.less=0;38;2;166;227;161:*.lisp=0;38;2;166;227;161:*.lock=0;38;2;88;91;112:*.make=0;38;2;148;226;213:*.mpeg=0;38;2;242;205;205:*.opus=0;38;2;242;205;205:*.orig=0;38;2;88;91;112:*.pptx=0;38;2;243;139;168:*.psd1=0;38;2;166;227;161:*.psm1=0;38;2;166;227;161:*.purs=0;38;2;166;227;161:*.rlib=0;38;2;88;91;112:*.sass=0;38;2;166;227;161:*.scss=0;38;2;166;227;161:*.tbz2=4;38;2;116;199;236:*.tiff=0;38;2;242;205;205:*.toml=0;38;2;249;226;175:*.webm=0;38;2;242;205;205:*.webp=0;38;2;242;205;205:*.woff=0;38;2;242;205;205:*.xbps=4;38;2;116;199;236:*.xlsx=0;38;2;243;139;168:*.yaml=0;38;2;249;226;175:*.cabal=0;38;2;166;227;161:*.cache=0;38;2;88;91;112:*.class=0;38;2;88;91;112:*.cmake=0;38;2;148;226;213:*.dyn_o=0;38;2;88;91;112:*.ipynb=0;38;2;166;227;161:*.mdown=0;38;2;249;226;175:*.patch=0;38;2;166;227;161:*.scala=0;38;2;166;227;161:*.shtml=0;38;2;249;226;175:*.swift=0;38;2;166;227;161:*.toast=4;38;2;116;199;236:*.xhtml=0;38;2;249;226;175:*README=0;38;2;30;30;46;48;2;249;226;175:*passwd=0;38;2;249;226;175:*shadow=0;38;2;249;226;175:*.config=0;38;2;249;226;175:*.dyn_hi=0;38;2;88;91;112:*.flake8=0;38;2;148;226;213:*.gradle=0;38;2;166;227;161:*.groovy=0;38;2;166;227;161:*.ignore=0;38;2;148;226;213:*.matlab=0;38;2;166;227;161:*COPYING=0;38;2;147;153;178:*INSTALL=0;38;2;30;30;46;48;2;249;226;175:*LICENSE=0;38;2;147;153;178:*TODO.md=1:*.desktop=0;38;2;249;226;175:*.gemspec=0;38;2;148;226;213:*Doxyfile=0;38;2;148;226;213:*Makefile=0;38;2;148;226;213:*TODO.txt=1:*setup.py=0;38;2;148;226;213:*.DS_Store=0;38;2;88;91;112:*.cmake.in=0;38;2;148;226;213:*.fdignore=0;38;2;148;226;213:*.kdevelop=0;38;2;148;226;213:*.markdown=0;38;2;249;226;175:*.rgignore=0;38;2;148;226;213:*COPYRIGHT=0;38;2;147;153;178:*README.md=0;38;2;30;30;46;48;2;249;226;175:*configure=0;38;2;148;226;213:*.gitconfig=0;38;2;148;226;213:*.gitignore=0;38;2;148;226;213:*.localized=0;38;2;88;91;112:*.scons_opt=0;38;2;88;91;112:*CODEOWNERS=0;38;2;148;226;213:*Dockerfile=0;38;2;249;226;175:*INSTALL.md=0;38;2;30;30;46;48;2;249;226;175:*README.txt=0;38;2;30;30;46;48;2;249;226;175:*SConscript=0;38;2;148;226;213:*SConstruct=0;38;2;148;226;213:*.gitmodules=0;38;2;148;226;213:*.synctex.gz=0;38;2;88;91;112:*.travis.yml=0;38;2;166;227;161:*INSTALL.txt=0;38;2;30;30;46;48;2;249;226;175:*LICENSE-MIT=0;38;2;147;153;178:*MANIFEST.in=0;38;2;148;226;213:*Makefile.am=0;38;2;148;226;213:*Makefile.in=0;38;2;88;91;112:*.applescript=0;38;2;166;227;161:*.fdb_latexmk=0;38;2;88;91;112:*CONTRIBUTORS=0;38;2;30;30;46;48;2;249;226;175:*appveyor.yml=0;38;2;166;227;161:*configure.ac=0;38;2;148;226;213:*.clang-format=0;38;2;148;226;213:*.gitattributes=0;38;2;148;226;213:*.gitlab-ci.yml=0;38;2;166;227;161:*CMakeCache.txt=0;38;2;88;91;112:*CMakeLists.txt=0;38;2;148;226;213:*LICENSE-APACHE=0;38;2;147;153;178:*CONTRIBUTORS.md=0;38;2;30;30;46;48;2;249;226;175:*.sconsign.dblite=0;38;2;88;91;112:*CONTRIBUTORS.txt=0;38;2;30;30;46;48;2;249;226;175:*requirements.txt=0;38;2;148;226;213:*package-lock.json=0;38;2;88;91;112:*.CFUserTextEncoding=0;38;2;88;91;112"
fi

# Load plugins.
# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#install -> fzf-tab after compinit, before zsh plugins which warp widgets
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)
# Enable the "new" completion system (compsys).
# Add plugins that change fpath above this - I nearly lost my sanity over this :/ 
if [ ! -d "$XDG_CACHE_HOME/zsh" ]; then mkdir -p "$XDG_CACHE_HOME/zsh"; fi
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/"
autoload -Uz compinit && compinit -u -d "${XDG_CACHE_HOME}/zsh/.zcompdump"

source $ZDOTDIR/plugins/clipboard/clipboard.plugin.zsh

if ! (($+commands[fzf])); then
	echo 'Warning: fzf is requried for the fzf-tab plugin but was not found.'
else
	export LESSOPEN="|$ZDOTDIR/lessfilter %s"
	setopt globdots
	zstyle ':completion:*' menu no
	zstyle ':fzf-tab:*' fzf-min-height 70
	zstyle ':completion:complete:*:argument-rest' sort false
	zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'  # case insensitive file matching
	zstyle ':completion:*' file-sort modification
	# switch group using `,`
	zstyle ':fzf-tab:*' switch-group ','
	# set list-colors to enable filename colorizing 
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	if [[ $OSTYPE != "msys" ]]; then # absolutly broken on msys2
		source $ZDOTDIR/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh
	fi
	source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh
fi

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zle_highlight+=(paste:none)
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME"/zsh-evalcache
source $ZDOTDIR/plugins/evalcache/evalcache.plugin.zsh

if [[ $TERM = "xterm-kitty" ]] && [[ -n $KITTY_INSTALLATION_DIR ]]; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
	kitty-integration
	unfunction kitty-integration
elif [[ $TERM_PROGRAM = "iTerm.app" ]]; then
	source "$ZDOTDIR/plugins/iTerm2-shell-integration/shell_integration/zsh"
fi

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
source $ZDOTDIR/.p10k.zsh ; source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme