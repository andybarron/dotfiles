#!/bin/false
# shellcheck shell=sh

# helper functions for POSIX shells

[ -n "${RC__SOURCE_HELPERS:-""}" ] && return 0
RC__SOURCE_HELPERS=1

. "$HOME/.dotfiles/source/env.sh"

# check if command exists; if not, add to missing commands list
rc__command_exists() {
  if rc__command_exists_optional "$1"; then
    return 0
  else
    if [ -z "$RC__MISSING_COMMANDS" ]; then
      export RC__MISSING_COMMANDS="$1"
    else
      export RC__MISSING_COMMANDS="$RC__MISSING_COMMANDS\n$1"
    fi
    return 1
  fi
}

# check if command exists, but don't warn if not
rc__command_exists_optional() {
  command -v "$1" > /dev/null 2>&1
}

# set global git config option unless it already has a value
rc__git_set_if_unset() {
  if [ -z "$(git config --global --get "$1")" ]; then
    git config --global "$1" "$2"
  fi
}

# clone git repository URL to directory matching repository name,
# it no such directory exists
rc__git_clone() {
  rc__git_repo_name="$(basename "$1" .git)"
  if [ ! -d "$RC__REPOS/$rc__git_repo_name" ]; then
    git clone "$1" "$RC__REPOS/$rc__git_repo_name"
  fi
  unset rc__git_repo_name
}

rc__info() {
  printf "\e[106m\e[30m[info ]\e[m \e[96m%s\e[m\n" "$*" >&2
}
rc__warn() {
  printf "\e[43m\e[30m[warn ]\e[m \e[33m%s\e[m\n" "$@" >&2
}
rc__error() {
  printf "\e[41m\e[30m[error]\e[m \e[31m%s\e[m\n" "$@" >&2
}

rc__warn_missing_commands() {
  if [ -n "$RC__MISSING_COMMANDS" ]; then
    rc__warn "missing commands: $(echo "$RC__MISSING_COMMANDS" | sort | uniq | tr '\n' ' ')"
  fi
}

if rc__command_exists_optional fortune; then
  rc__quote_path() {
    rc__last_quote_dir="$RC__QUOTES/$(date +"%Y/%m/%d")"
    mkdir -p "$rc__last_quote_dir"
    echo "$rc__last_quote_dir/quote.txt"
    unset rc__last_quote_dir
  }

  rc__quote() {
    if [ ! -f "$(rc__quote_path)" ]; then
      fortune -s > "$(rc__quote_path)"
    fi

    if rc__command_exists_optional lolcat; then
      lolcat "$(rc__quote_path)"
    else
      cat "$(rc__quote_path)"
    fi
  }

  rc__requote() {
    rm -f "$(rc__quote_path)"
    rc__quote
  }
fi
