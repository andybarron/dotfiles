CARGO_ENV="$HOME/.cargo/env"

source "$HOME/.dotfiles/source/env.sh"
test -f "$CARGO_ENV" && source "$CARGO_ENV"
