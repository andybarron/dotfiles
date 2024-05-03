#!/bin/false
# shellcheck shell=sh

# aliases for interactive POSIX shells

. "$HOME/.dotfiles/source/env.sh"
. "$RC__SOURCE/check-interactive.sh"

alias g='git'

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gbd='git branch --delete'
alias gbm='git branch --move'

alias gc='git commit'
alias gca='git commit --all'
alias gcam='git commit --all --message'
alias gcm='git commit --message'

alias gd='git diff'
alias gds='git diff --staged'

alias gl='git log'
alias glo='git log --oneline'

alias gst='git status'

alias gsw='git switch'
alias gswc='git switch -c'

alias gl='git pull'

alias gp='git push'
alias gpf='git push --force-with-lease'

alias gundo='git reset HEAD~1'
alias gredo='git commit --reuse-message ORIG_HEAD'
# weird quoting due to zsh syntax highlighting bug
# shellcheck disable=SC2139
alias gsync="$RC__SCRIPTS/git-sync"

alias la='l -A'
alias ll='l -l'
alias lt='l --tree'
alias lal='l -Al'
alias lat='l -A --tree'
alias llt='l -l --tree'
alias lalt='l -Al --tree'

# TODO: do this without polluting env if no command is passed
alias dotfiles='GIT_DIR="$RC__GIT_DIR" GIT_WORK_TREE="$HOME"'
alias undotfiles='unset GIT_DIR GIT_WORK_TREE'
alias dtf='dotfiles'
alias undtf='undotfiles'

alias grep='command grep --color=auto'

# ssh and launch tmux in control mode
ssht() {
  ssh "$@" -t "tmux -CC new -A -s 0"
}
