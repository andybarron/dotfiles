#!/bin/false
# shellcheck shell=sh

# source this file to attach to multiplexer (zellij, tmux)
# if available and enabled.

test "$TERM_PROGRAM" = "vscode" && return 0
test "$TERM_PROGRAM" = "WezTerm" && return 0

. "$HOME/.dotfiles/source/env.sh"
. "$RC__SOURCE/check-interactive.sh"
. "$RC__SOURCE/helpers.sh"

if test -n "$RC__ENABLE_ZELLIJ"; then
  rc__command_exists zellij &&
    test -z "$ZELLIJ" &&
    exec zellij attach -c default
fi

if test -n "$RC__TMUX_ATTACH"; then
  rc__command_exists tmux &&
    test -z "$TMUX" &&
    if test -n "$RC__TMUX_CONTROL_MODE"; then
      exec tmux -CC new-session -As default
    else
      exec tmux new-session -As default
    fi
fi
