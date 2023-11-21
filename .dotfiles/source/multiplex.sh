#!/bin/false
# shellcheck shell=sh

# source this file to attach to multiplexer (zellij, tmux)
# if available and enabled.

. "$HOME/.dotfiles/source/env.sh"
. "$RC__SOURCE/check-interactive.sh"
. "$RC__SOURCE/helpers.sh"

if test -n "$RC__ENABLE_ZELLIJ"; then
  rc__command_exists zellij &&
    test -z "$ZELLIJ" &&
    exec zellij attach -c default
fi

if test -n "$RC__ENABLE_TMUX"; then
  rc__command_exists tmux &&
    test -z "$TMUX" &&
    exec tmux new-session -As default
fi
