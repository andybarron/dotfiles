#!/bin/false
# shellcheck shell=sh

# define environment variables for all shells,
# including non-interactive ones.

[ -n "${RC__SOURCE_ENV:-""}" ] && return 0
RC__SOURCE_ENV=1

# custom environment variables used by custom configs
export RC__ROOT=~/.dotfiles
export RC__SCRIPTS="$RC__ROOT/scripts"
export RC__SOURCE="$RC__ROOT/source"
export RC__LOCAL="$RC__ROOT/local"
export RC__REPOS="$RC__LOCAL/repos"
export RC__GIT_DIR="$RC__ROOT/.gitbare"
export RC__QUOTES="$RC__LOCAL/quotes"
export RC__MISSING_COMMANDS=""

# include local binaries e.g. pip installs
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# include homebrew binaries
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

test -f "$RC__LOCAL/env.sh" && . "$RC__LOCAL/env.sh"
