#!/bin/false
# shellcheck shell=sh

# source this file to attach to multiplexer (zellij, tmux)
# if available and enabled.

# enable zellij: touch $RC__ROOT/.enable-zellij
# enable tmux: touch $RC__ROOT/.enable-tmux

. "$HOME/.dotfiles/source/env.sh"
. "$RC__SOURCE/check-interactive.sh"
. "$RC__SOURCE/helpers.sh"

if test -f "$RC__ROOT/.enable-zellij"; then
  rc__command_exists zellij && \
    test -z "$ZELLIJ" && \
    exec zellij attach -c default
fi

if test -f "$RC__ROOT/.enable-tmux"; then
  rc__command_exists tmux && \
    test -z "$TMUX" && \
    exec tmux new-session -As main
fi
