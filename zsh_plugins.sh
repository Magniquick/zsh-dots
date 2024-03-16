#!/bin/zsh
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
  zcompile-many $XDG_CACHE_HOME/p10k-instant-prompt-*.zsh &

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
  zcompile-many $XDG_CACHE_HOME/zsh/zcompcache/^(*.(zwc|old)) &
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
  git clone --depth=1  --recursive --shallow-submodules https://github.com/Aloxaf/fzf-tab.git $ZDOTDIR/plugins/fzf-tab # uses a pr for auto prefix matching
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
if [[ ! -e $ZDOTDIR/plugins/clipboard ]]; then
  git clone --depth=1 --recursive --shallow-submodules https://github.com/zpm-zsh/clipboard.git $ZDOTDIR/plugins/clipboard
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

# Generated using $(vivid generate catppuccin-macchiato)
# https://github.com/sharkdp/vivid
export LS_COLORS="*~=0;38;2;91;96;120:bd=0;38;2;125;196;228;48;2;54;58;79:ca=0:cd=0;38;2;245;189;230;48;2;54;58;79:di=0;38;2;138;173;244:do=0;38;2;24;25;38;48;2;245;189;230:ex=1;38;2;237;135;150:fi=0:ln=0;38;2;245;189;230:mh=0:mi=0;38;2;24;25;38;48;2;237;135;150:no=0:or=0;38;2;24;25;38;48;2;237;135;150:ow=0:pi=0;38;2;24;25;38;48;2;138;173;244:rs=0:sg=0:so=0;38;2;24;25;38;48;2;245;189;230:st=0:su=0:tw=0:*.a=1;38;2;237;135;150:*.c=0;38;2;166;218;149:*.d=0;38;2;166;218;149:*.h=0;38;2;166;218;149:*.m=0;38;2;166;218;149:*.o=0;38;2;91;96;120:*.p=0;38;2;166;218;149:*.r=0;38;2;166;218;149:*.t=0;38;2;166;218;149:*.z=4;38;2;125;196;228:*.7z=4;38;2;125;196;228:*.as=0;38;2;166;218;149:*.bc=0;38;2;91;96;120:*.bz=4;38;2;125;196;228:*.cc=0;38;2;166;218;149:*.cp=0;38;2;166;218;149:*.cr=0;38;2;166;218;149:*.cs=0;38;2;166;218;149:*.di=0;38;2;166;218;149:*.el=0;38;2;166;218;149:*.ex=0;38;2;166;218;149:*.fs=0;38;2;166;218;149:*.go=0;38;2;166;218;149:*.gv=0;38;2;166;218;149:*.gz=4;38;2;125;196;228:*.hh=0;38;2;166;218;149:*.hi=0;38;2;91;96;120:*.hs=0;38;2;166;218;149:*.jl=0;38;2;166;218;149:*.js=0;38;2;166;218;149:*.ko=1;38;2;237;135;150:*.kt=0;38;2;166;218;149:*.la=0;38;2;91;96;120:*.ll=0;38;2;166;218;149:*.lo=0;38;2;91;96;120:*.md=0;38;2;238;212;159:*.ml=0;38;2;166;218;149:*.mn=0;38;2;166;218;149:*.nb=0;38;2;166;218;149:*.pl=0;38;2;166;218;149:*.pm=0;38;2;166;218;149:*.pp=0;38;2;166;218;149:*.ps=0;38;2;237;135;150:*.py=0;38;2;166;218;149:*.rb=0;38;2;166;218;149:*.rm=0;38;2;240;198;198:*.rs=0;38;2;166;218;149:*.sh=0;38;2;166;218;149:*.so=1;38;2;237;135;150:*.td=0;38;2;166;218;149:*.ts=0;38;2;166;218;149:*.ui=0;38;2;238;212;159:*.vb=0;38;2;166;218;149:*.wv=0;38;2;240;198;198:*.xz=4;38;2;125;196;228:*.aif=0;38;2;240;198;198:*.ape=0;38;2;240;198;198:*.apk=4;38;2;125;196;228:*.arj=4;38;2;125;196;228:*.asa=0;38;2;166;218;149:*.aux=0;38;2;91;96;120:*.avi=0;38;2;240;198;198:*.awk=0;38;2;166;218;149:*.bag=4;38;2;125;196;228:*.bak=0;38;2;91;96;120:*.bat=1;38;2;237;135;150:*.bbl=0;38;2;91;96;120:*.bcf=0;38;2;91;96;120:*.bib=0;38;2;238;212;159:*.bin=4;38;2;125;196;228:*.blg=0;38;2;91;96;120:*.bmp=0;38;2;240;198;198:*.bsh=0;38;2;166;218;149:*.bst=0;38;2;238;212;159:*.bz2=4;38;2;125;196;228:*.c++=0;38;2;166;218;149:*.cfg=0;38;2;238;212;159:*.cgi=0;38;2;166;218;149:*.clj=0;38;2;166;218;149:*.com=1;38;2;237;135;150:*.cpp=0;38;2;166;218;149:*.css=0;38;2;166;218;149:*.csv=0;38;2;238;212;159:*.csx=0;38;2;166;218;149:*.cxx=0;38;2;166;218;149:*.deb=4;38;2;125;196;228:*.def=0;38;2;166;218;149:*.dll=1;38;2;237;135;150:*.dmg=4;38;2;125;196;228:*.doc=0;38;2;237;135;150:*.dot=0;38;2;166;218;149:*.dox=0;38;2;139;213;202:*.dpr=0;38;2;166;218;149:*.elc=0;38;2;166;218;149:*.elm=0;38;2;166;218;149:*.epp=0;38;2;166;218;149:*.eps=0;38;2;240;198;198:*.erl=0;38;2;166;218;149:*.exe=1;38;2;237;135;150:*.exs=0;38;2;166;218;149:*.fls=0;38;2;91;96;120:*.flv=0;38;2;240;198;198:*.fnt=0;38;2;240;198;198:*.fon=0;38;2;240;198;198:*.fsi=0;38;2;166;218;149:*.fsx=0;38;2;166;218;149:*.gif=0;38;2;240;198;198:*.git=0;38;2;91;96;120:*.gvy=0;38;2;166;218;149:*.h++=0;38;2;166;218;149:*.hpp=0;38;2;166;218;149:*.htc=0;38;2;166;218;149:*.htm=0;38;2;238;212;159:*.hxx=0;38;2;166;218;149:*.ico=0;38;2;240;198;198:*.ics=0;38;2;237;135;150:*.idx=0;38;2;91;96;120:*.ilg=0;38;2;91;96;120:*.img=4;38;2;125;196;228:*.inc=0;38;2;166;218;149:*.ind=0;38;2;91;96;120:*.ini=0;38;2;238;212;159:*.inl=0;38;2;166;218;149:*.ipp=0;38;2;166;218;149:*.iso=4;38;2;125;196;228:*.jar=4;38;2;125;196;228:*.jpg=0;38;2;240;198;198:*.kex=0;38;2;237;135;150:*.kts=0;38;2;166;218;149:*.log=0;38;2;91;96;120:*.ltx=0;38;2;166;218;149:*.lua=0;38;2;166;218;149:*.m3u=0;38;2;240;198;198:*.m4a=0;38;2;240;198;198:*.m4v=0;38;2;240;198;198:*.mid=0;38;2;240;198;198:*.mir=0;38;2;166;218;149:*.mkv=0;38;2;240;198;198:*.mli=0;38;2;166;218;149:*.mov=0;38;2;240;198;198:*.mp3=0;38;2;240;198;198:*.mp4=0;38;2;240;198;198:*.mpg=0;38;2;240;198;198:*.nix=0;38;2;238;212;159:*.odp=0;38;2;237;135;150:*.ods=0;38;2;237;135;150:*.odt=0;38;2;237;135;150:*.ogg=0;38;2;240;198;198:*.org=0;38;2;238;212;159:*.otf=0;38;2;240;198;198:*.out=0;38;2;91;96;120:*.pas=0;38;2;166;218;149:*.pbm=0;38;2;240;198;198:*.pdf=0;38;2;237;135;150:*.pgm=0;38;2;240;198;198:*.php=0;38;2;166;218;149:*.pid=0;38;2;91;96;120:*.pkg=4;38;2;125;196;228:*.png=0;38;2;240;198;198:*.pod=0;38;2;166;218;149:*.ppm=0;38;2;240;198;198:*.pps=0;38;2;237;135;150:*.ppt=0;38;2;237;135;150:*.pro=0;38;2;139;213;202:*.ps1=0;38;2;166;218;149:*.psd=0;38;2;240;198;198:*.pyc=0;38;2;91;96;120:*.pyd=0;38;2;91;96;120:*.pyo=0;38;2;91;96;120:*.rar=4;38;2;125;196;228:*.rpm=4;38;2;125;196;228:*.rst=0;38;2;238;212;159:*.rtf=0;38;2;237;135;150:*.sbt=0;38;2;166;218;149:*.sql=0;38;2;166;218;149:*.sty=0;38;2;91;96;120:*.svg=0;38;2;240;198;198:*.swf=0;38;2;240;198;198:*.swp=0;38;2;91;96;120:*.sxi=0;38;2;237;135;150:*.sxw=0;38;2;237;135;150:*.tar=4;38;2;125;196;228:*.tbz=4;38;2;125;196;228:*.tcl=0;38;2;166;218;149:*.tex=0;38;2;166;218;149:*.tgz=4;38;2;125;196;228:*.tif=0;38;2;240;198;198:*.tml=0;38;2;238;212;159:*.tmp=0;38;2;91;96;120:*.toc=0;38;2;91;96;120:*.tsx=0;38;2;166;218;149:*.ttf=0;38;2;240;198;198:*.txt=0;38;2;238;212;159:*.vcd=4;38;2;125;196;228:*.vim=0;38;2;166;218;149:*.vob=0;38;2;240;198;198:*.wav=0;38;2;240;198;198:*.wma=0;38;2;240;198;198:*.wmv=0;38;2;240;198;198:*.xcf=0;38;2;240;198;198:*.xlr=0;38;2;237;135;150:*.xls=0;38;2;237;135;150:*.xml=0;38;2;238;212;159:*.xmp=0;38;2;238;212;159:*.yml=0;38;2;238;212;159:*.zip=4;38;2;125;196;228:*.zsh=0;38;2;166;218;149:*.zst=4;38;2;125;196;228:*TODO=1:*hgrc=0;38;2;139;213;202:*.bash=0;38;2;166;218;149:*.conf=0;38;2;238;212;159:*.dart=0;38;2;166;218;149:*.diff=0;38;2;166;218;149:*.docx=0;38;2;237;135;150:*.epub=0;38;2;237;135;150:*.fish=0;38;2;166;218;149:*.flac=0;38;2;240;198;198:*.h264=0;38;2;240;198;198:*.hgrc=0;38;2;139;213;202:*.html=0;38;2;238;212;159:*.java=0;38;2;166;218;149:*.jpeg=0;38;2;240;198;198:*.json=0;38;2;238;212;159:*.less=0;38;2;166;218;149:*.lisp=0;38;2;166;218;149:*.lock=0;38;2;91;96;120:*.make=0;38;2;139;213;202:*.mpeg=0;38;2;240;198;198:*.opus=0;38;2;240;198;198:*.orig=0;38;2;91;96;120:*.pptx=0;38;2;237;135;150:*.psd1=0;38;2;166;218;149:*.psm1=0;38;2;166;218;149:*.purs=0;38;2;166;218;149:*.rlib=0;38;2;91;96;120:*.sass=0;38;2;166;218;149:*.scss=0;38;2;166;218;149:*.tbz2=4;38;2;125;196;228:*.tiff=0;38;2;240;198;198:*.toml=0;38;2;238;212;159:*.webm=0;38;2;240;198;198:*.webp=0;38;2;240;198;198:*.woff=0;38;2;240;198;198:*.xbps=4;38;2;125;196;228:*.xlsx=0;38;2;237;135;150:*.yaml=0;38;2;238;212;159:*.cabal=0;38;2;166;218;149:*.cache=0;38;2;91;96;120:*.class=0;38;2;91;96;120:*.cmake=0;38;2;139;213;202:*.dyn_o=0;38;2;91;96;120:*.ipynb=0;38;2;166;218;149:*.mdown=0;38;2;238;212;159:*.patch=0;38;2;166;218;149:*.scala=0;38;2;166;218;149:*.shtml=0;38;2;238;212;159:*.swift=0;38;2;166;218;149:*.toast=4;38;2;125;196;228:*.xhtml=0;38;2;238;212;159:*README=0;38;2;36;39;58;48;2;238;212;159:*passwd=0;38;2;238;212;159:*shadow=0;38;2;238;212;159:*.config=0;38;2;238;212;159:*.dyn_hi=0;38;2;91;96;120:*.flake8=0;38;2;139;213;202:*.gradle=0;38;2;166;218;149:*.groovy=0;38;2;166;218;149:*.ignore=0;38;2;139;213;202:*.matlab=0;38;2;166;218;149:*COPYING=0;38;2;147;154;183:*INSTALL=0;38;2;36;39;58;48;2;238;212;159:*LICENSE=0;38;2;147;154;183:*TODO.md=1:*.desktop=0;38;2;238;212;159:*.gemspec=0;38;2;139;213;202:*Doxyfile=0;38;2;139;213;202:*Makefile=0;38;2;139;213;202:*TODO.txt=1:*setup.py=0;38;2;139;213;202:*.DS_Store=0;38;2;91;96;120:*.cmake.in=0;38;2;139;213;202:*.fdignore=0;38;2;139;213;202:*.kdevelop=0;38;2;139;213;202:*.markdown=0;38;2;238;212;159:*.rgignore=0;38;2;139;213;202:*COPYRIGHT=0;38;2;147;154;183:*README.md=0;38;2;36;39;58;48;2;238;212;159:*configure=0;38;2;139;213;202:*.gitconfig=0;38;2;139;213;202:*.gitignore=0;38;2;139;213;202:*.localized=0;38;2;91;96;120:*.scons_opt=0;38;2;91;96;120:*CODEOWNERS=0;38;2;139;213;202:*Dockerfile=0;38;2;238;212;159:*INSTALL.md=0;38;2;36;39;58;48;2;238;212;159:*README.txt=0;38;2;36;39;58;48;2;238;212;159:*SConscript=0;38;2;139;213;202:*SConstruct=0;38;2;139;213;202:*.gitmodules=0;38;2;139;213;202:*.synctex.gz=0;38;2;91;96;120:*.travis.yml=0;38;2;166;218;149:*INSTALL.txt=0;38;2;36;39;58;48;2;238;212;159:*LICENSE-MIT=0;38;2;147;154;183:*MANIFEST.in=0;38;2;139;213;202:*Makefile.am=0;38;2;139;213;202:*Makefile.in=0;38;2;91;96;120:*.applescript=0;38;2;166;218;149:*.fdb_latexmk=0;38;2;91;96;120:*CONTRIBUTORS=0;38;2;36;39;58;48;2;238;212;159:*appveyor.yml=0;38;2;166;218;149:*configure.ac=0;38;2;139;213;202:*.clang-format=0;38;2;139;213;202:*.gitattributes=0;38;2;139;213;202:*.gitlab-ci.yml=0;38;2;166;218;149:*CMakeCache.txt=0;38;2;91;96;120:*CMakeLists.txt=0;38;2;139;213;202:*LICENSE-APACHE=0;38;2;147;154;183:*CONTRIBUTORS.md=0;38;2;36;39;58;48;2;238;212;159:*.sconsign.dblite=0;38;2;91;96;120:*CONTRIBUTORS.txt=0;38;2;36;39;58;48;2;238;212;159:*requirements.txt=0;38;2;139;213;202:*package-lock.json=0;38;2;91;96;120:*.CFUserTextEncoding=0;38;2;91;96;120"

# Load plugins.
# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#install -> fzf-tab after compinit, before zsh plugins which warp widgets
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)
# Enable the "new" completion system (compsys).
# Add plugins that change fpath above this - I nearly lost my sanity over this :/ 
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/"
autoload -Uz compinit && compinit -u -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache/.zcompdump"

source $ZDOTDIR/plugins/clipboard/clipboard.plugin.zsh

export LESSOPEN="|$ZDOTDIR/lessfilter %s"
setopt globdots
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-min-height 70
zstyle ':completion:complete:*:argument-rest' sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'  # case insensitive file matching
# switch group using `,`
zstyle ':fzf-tab:*' switch-group ','
# set list-colors to enable filename colorizing 
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
source $ZDOTDIR/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ $TERM_PROGRAM = "iTerm.app" ]]; then
  source "$ZDOTDIR/plugins/iterm2/shell_integration/zsh"
fi

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme