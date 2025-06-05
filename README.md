# Zsh-dotfiles !
Just my zsh dots : P \
Designed to be as fast as humanly possible (benchmarked with [zsh-bench](https://github.com/romkatv/zsh-bench)), while having every single plugin you could need.
## Setup:
Clone this to ~/.config/zsh using
```sh
git clone --recursive https://github.com/Magniquick/zsh-dots ~/.config/zsh
```
and create/appened to /etc/zshenv (or /etc/zsh/zshenv, depending on your distro) the the following -
```sh
export ZDOTDIR="$HOME"/.config/zsh
```
after that, run
```sh
zsh_setup
```
to setup optional theming, compiling, and other stuff.
## Requirements 
Necessary - fzf. \
Optional - timg, atutin, and preferably kitty/iTerm2.
## Contributing
Open a issue, add the output of $TERM_PROGRAM and which format is used by your terminal on https://github.com/hzeller/timg to add image preview support there.
Alternatively, add it to lessfilter and open a pr !

Happy hacking !
