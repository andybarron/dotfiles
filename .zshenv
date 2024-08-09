typeset -U path PATH

# local binaries e.g. pip installs
path+=("$HOME/.local/bin")

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# homebrew binaries
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# local env overrides
[ -f "$HOME/.override.zshenv" ] && source "$HOME/.override.zshenv"
