# https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
# TLDR: path_helper is weird on mac, so avoid .zshenv

typeset -U path PATH fpath FPATH # prevent duplicates

# handled manually in .zshrc, or by zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete
skip_global_compinit=1

# prepend asdf to path
path=("${ASDF_DATA_DIR:-$HOME/.asdf}/shims" $path)

# local binaries e.g. pip installs
path+=("$HOME/.local/bin")

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# add rvm to path (if installed)
[ -d "$HOME/.rvm/bin" ] && path+=("$HOME/.rvm/bin")

# homebrew binaries
[ -d /opt/homebrew/bin ] && path=("/opt/homebrew/bin" $path)

# local env overrides
[ -f "${ZDOTDIR:-$HOME}/.$(hostname).zshenv" ] && source "${ZDOTDIR:-$HOME}/.$(hostname).zshenv"
[ -f "${ZDOTDIR:-$HOME}/.local.zshenv" ] && source "${ZDOTDIR:-$HOME}/.local.zshenv"
