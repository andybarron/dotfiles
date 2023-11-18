#!/bin/false
# shellcheck shell=sh

# aliases for POSIX shells

. "$HOME/.dotfiles/source/env.sh"

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
alias gsync='"$RC__SCRIPTS"/gsync'

alias la='l -A'
alias ll='l -l'
alias lt='l --tree'
alias lal='l -Al'
alias lat='l -A --tree'
alias llt='l -l --tree'
alias lalt='l -Al --tree'

alias dotfiles='GIT_DIR="$RC__GIT_DIR" GIT_WORK_TREE="$HOME"'
alias undotfiles='unset GIT_DIR GIT_WORK_TREE'
alias dtf='dotfiles'
alias undtf='undotfiles'

alias grep='command grep --color auto'
