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
Optional - atutin, and preferably kitty/iTerm2.
## Contributing
Open a issue, add the output of $TERM_PROGRAM and which format is used by your terminal on https://github.com/hzeller/timg to add image preview support there.
Alternatively, add it to lessfilter and open a pr !

Happy hacking !

## Startup timing

| Scenario | Description | Mean (ms) | Notes |
|---|---|---|---|
| baseline | Full config with `env.zsh`, `zsh_plugins.zsh`, `random.zsh`, `zoxide`, and `atuin` | 96.7 ± 1.4 | Reference run with no `.zwc` cache |
| no env/random | Skip `env.zsh` + `random.zsh` (so the plugin stack and `codex completion` are disabled) | 27.1 ± 0.3 | The big ~70 ms chunk comes from the plugin stack |
| no env/random/zoxide | Also skip `zoxide` initialization | 25.1 ± 0.2 | Tiny additional gain from delaying the auto-completion hook |
| no env/random/zoxide/atuin | Plus disable the `atuin` block (autosuggestions strategy) | 17.2 ± 0.2 | Autosuggestions now take the measurable remainder, leaving ~7 ms of other hooks |
| `--no-rcs` | Zsh without any dotfiles | 10.0 ± 0.2 | Baseline shell cost without your configuration |

So the residual ~85–90 ms runtime is mostly `env/zsh_plugins` → instant prompt → `compinit`/completion/zsh plugin stack, with `codex completion`, `zoxide`, and `atuin` making smaller but measurable contributions. Skipping those pieces (or lazily loading them) is what brings you closest to the `--no-rcs` number.

## Eval caching

`zsh-smartcache` is now loaded from `plugins/zsh-smartcache`, and the heavy `eval` calls (`codex completion zsh`, `zoxide init zsh`, `atuin init zsh --disable-up-arrow`) go through `smartcache eval …`. Cache files live inside `~/.cache/zsh`, and they are kept in sync in the background so subsequent shells instantly reuse the cached output without rerunning the commands.

## Profiling breakdown

Measured with `ZDOTDIR=/home/magni/.config/zsh zsh -f -c 'zmodload zsh/zprof; source $ZDOTDIR/.zshrc; zprof'`.

| Function / block | Time (ms) | Share |
|---|---|---|
| `_zsh_highlight_bind_widgets` | 14.6 | 30% | Fast syntax highlighting wraps widgets while the shell loads. |
| `compinit` | 13.1 | 27% | Building the completion cache (insecure-directory portion). |
| `enable-fzf-tab` | 10.5 | 22% | The fzf-tab source/widget setup that relies on the cached completion hooks. |
| `kitty-integration` | 4.0 | 8% | Kitty/iTerm shell-integration `autoload` block. |
| `add-zle-hook-widget` / `add-zsh-hook` | ~2.0 | 5% | Zsh hooks wired by the plugin stack (autosuggestions / zoxide). |
| other helpers (autosuggestions, fast-syntax-highlighting, fzf tab helpers) | <1 | ~2% | Smaller helpers that still show up in the profiling report. |

Total of the profiled functions adds up to about 45 ms; the rest of the ≈80 ms headroom is the cost of launching zsh + sourcing `env.zsh`/`zsh_plugins.zsh` before zprof even starts recording.
