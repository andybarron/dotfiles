zmodload zsh/zprof

source "$RC__SOURCE/multiplex.sh"

source "$RC__SOURCE/helpers.sh"

setopt interactive_comments
bindkey -e

rc__quote

mkdir -p ~/.zfunc
fpath+=~/.zfunc

rc__git_clone https://github.com/mattmc3/antidote.git
zstyle ':antidote:bundle' use-friendly-names 'yes'
source "$RC__REPOS/antidote/antidote.zsh"
antidote load

if rc__command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

if rc__command_exists rustup; then
  [[ ! -f ~/.zfunc/_rustup ]] && rustup completions zsh > ~/.zfunc/_rustup
  [[ ! -f ~/.zfunc/_cargo ]] && rustup completions zsh cargo > ~/.zfunc/_cargo
fi

source "$RC__SOURCE/interactive.sh"

autoload -Uz promptinit && promptinit && prompt pure
