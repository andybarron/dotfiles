zmodload zsh/zprof

source "$RC__SOURCE/multiplex.sh"

source "$RC__SOURCE/helpers.sh"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt histignoredups
setopt interactive_comments
bindkey -e

rc__command_exists_optional rc__quote && rc__quote

mkdir -p ~/.zfunc
fpath+=~/.zfunc

if rc__command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

if rc__command_exists_optional rustup; then
  [[ ! -f ~/.zfunc/_rustup ]] && rustup completions zsh >~/.zfunc/_rustup
  [[ ! -f ~/.zfunc/_cargo ]] && rustup completions zsh cargo >~/.zfunc/_cargo
fi

source "$RC__SOURCE/interactive.sh"

zstyle :antidote:bundle use-friendly-names yes
zstyle :omz:plugins:ssh-agent lazy yes
source "$RC__REPOS/antidote/antidote.zsh"
antidote load

# TODO: this is a bad place for this and i'm mad about it
compdef '_dispatch ssh ssh' ssht

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
ZSH_HIGHLIGHT_STYLES[comment]="fg=8,bold"

autoload -Uz promptinit && promptinit && prompt pure
