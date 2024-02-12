# Zsh-dotfiles !
Just my zsh dots : P
## Setup:
clone this to ~/.config/zsh, and create a .zshenv file in ~ with the the following -
```zsh
ZDOTDIR=~/.config/zsh
[[ ! -f "$ZDOTDIR"/.zshenv ]] || source -- "$ZDOTDIR"/.zshenv
```
## Contibuting
open a issue, add the output of $TERM_PROGRAM and which format is used by your terminal on https://github.com/hzeller/timg to add image preview support there.
alternatively, add it to lessfilter and open a pr !

Happy hacking !
