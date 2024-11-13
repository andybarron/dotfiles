typeset -U path PATH fpath FPATH # prevent duplicates

# handled manually in .zshrc, or by zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete
skip_global_compinit=1

# local binaries e.g. pip installs
path+=("$HOME/.local/bin")

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# add rvm to path (if installed)
[ -d "$HOME/.rvm/bin" ] && path+=("$HOME/.rvm/bin")

# homebrew binaries
[ -d /opt/homebrew/bin ] && path=("/opt/homebrew/bin" $path)

# local env overrides
[ -f "${ZDOTDIR:-$HOME}/.local.zshenv" ] && source "${ZDOTDIR:-$HOME}/.local.zshenv"
