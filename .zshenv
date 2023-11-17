# include local binaries e.g. pip installs
export PATH="$HOME/.local/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# allow local overrides
[[ -f "$HOME/.zshenv.local.zsh" ]] && source "$HOME/.zshenv.local.zsh"
