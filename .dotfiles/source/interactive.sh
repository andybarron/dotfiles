#!/bin/false
# shellcheck shell=sh

# init script to source for all interactive (POSIX) shells

[ -n "${RC__SOURCE_INTERACTIVE:-""}" ] && return 0
RC__SOURCE_INTERACTIVE=1

RC__CLONE_REPOS=$(
  cat <<EOF
https://github.com/alacritty/alacritty-theme.git
https://github.com/mattmc3/antidote.git
EOF
)

. "$HOME/.dotfiles/source/env.sh"
. "$RC__SOURCE/check-interactive.sh"
. "$RC__SOURCE/helpers.sh"
. "$RC__SOURCE/aliases.sh"

# clone repos for various tools
echo "$RC__CLONE_REPOS" | while IFS= read -r repo; do
  rc__git_clone "$repo"
done

# ensure dotfiles git config is synced
git --git-dir="$RC__GIT_DIR" config --local include.path '../.gitconfig'

# set up EDITOR variable
if rc__command_exists nvim; then
  export VISUAL=nvim
  alias v=nvim
else
  export VISUAL=vim
  alias v=vim
fi

# set up lsd if found
if rc__command_exists lsd; then
  alias l='lsd --date=relative'
else
  alias l='ls -h --color=auto'
fi

# TODO: broken due to https://github.com/nvbn/thefuck/issues/1372
# # set up thefuck if found
# if rc__command_exists thefuck; then
#   eval "$(thefuck --alias)"
# fi

# copy local template files
for template_path in "$RC__LOCAL"/templates/*; do
  rc__template_name=$(basename "$template_path")
  test -f "$RC__LOCAL/$rc__template_name" || cp "$template_path" "$RC__LOCAL/$rc__template_name"
  unset rc__template_name
done

. "$RC__SOURCE/warn-missing.sh"
