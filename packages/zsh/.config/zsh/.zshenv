typeset -U path PATH fpath FPATH # prevent duplicates

# handled manually in .zshrc, or by zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete
skip_global_compinit=1

# local binaries e.g. pip installs
path+=("$HOME/.local/bin")

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# homebrew binaries
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# local env overrides
[ -f "${ZDOTDIR:-$HOME}/.local.zshenv" ] && source "${ZDOTDIR:-$HOME}/.local.zshenv"
