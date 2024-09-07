zmodload zsh/zprof

dotfiles__repos_dir="$HOME/.dotfiles/repos"

dotfiles__missing_commands=()
typeset -U dotfiles__missing_commands

ZDOTDIR="${ZDOTDIR:-$HOME}"

function zshrc::init {
  # configure zsh options
  HISTFILE="$ZDOTDIR/.zsh_history"
  HISTSIZE=100000
  SAVEHIST=100000
  bindkey -e
  setopt bang_hist
  setopt complete_in_word
  setopt extended_history
  setopt hash_list_all
  setopt hist_expire_dups_first
  setopt hist_find_no_dups
  setopt hist_ignore_all_dups
  setopt hist_ignore_space
  setopt hist_verify
  setopt inc_append_history
  setopt interactive_comments
  setopt share_history

  # configure git
  git config --global include.path "~/.dotfiles/configs/git/default.gitconfig"

  # load zoxide
  if zshrc::command_exists zoxide; then
    eval "$(zoxide init zsh)"
  fi

  # set editor variable
  if zshrc::command_exists nvim; then
    export VISUAL=nvim
    alias v=nvim
  else
    export VISUAL=vim
    alias v=vim
  fi

  # if we're in a vscode terminal, set editor to code wait mode.
  # we wrap code in a script because the VISUAL variable does not
  # support arguments.
  if [[ "$TERM_PROGRAM" == "vscode" ]] && command -v code &>/dev/null; then
    export VISUAL="$HOME/.config/zsh/code.zsh"
  fi

  # set up lsd if found
  if zshrc::command_exists lsd; then
    alias l='lsd --date=relative'
  else
    alias l='ls -h --color=auto'
  fi

  # set up direnv if found
  if zshrc::command_exists_optional direnv; then
    eval "$(direnv hook zsh)"
  fi

  # git aliases
  alias g='git'

  alias ga='git add'
  alias gaa='git add --all'

  alias gb='git branch'
  alias gbd='git branch --delete'
  alias gbm='git branch --move'

  alias gc='git commit'
  alias gca='git commit --all'
  alias gcam='git commit --all --message'
  alias gcamn='git commit --all -n --message'
  alias gcm='git commit --message'
  alias gcmn='git commit -n --message'

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

  # ls aliases
  alias la='l -A'
  alias ll='l -l'
  alias lt='l --tree'
  alias lal='l -Al'
  alias lat='l -A --tree'
  alias llt='l -l --tree'
  alias lalt='l -Al --tree'

  # other aliases
  alias grep='command grep --color=auto'
  tm() {
    tmux new -As "${1:-0}"
  }

  # set up zsh plugins

  # zsh syntax highlighting
  . "$dotfiles__repos_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
  ZSH_HIGHLIGHT_STYLES[comment]="fg=8,bold"

  # zsh completions
  fpath+="$dotfiles__repos_dir/zsh-completions/src"

  # asdf completions
  fpath+="$ASDF_DIR/completions"

  # if homebrew exists, use package completions
  if zshrc::command_exists_optional brew; then
    fpath+=$(brew --prefix)/share/zsh/site-functions
  fi

  # zsh autocomplete (interactive drop-down completions)
  # https://github.com/marlonrichert/zsh-autocomplete
  # "near the top, before any calls to compinit"
  # must be after syntax highlighting:
  # https://github.com/zsh-users/zsh-syntax-highlighting/issues/951
  # calls compinit, so should be after fpath modifications:
  # https://www.reddit.com/r/zsh/comments/gk2c91/comment/kpjmntg
  . "$dotfiles__repos_dir/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

  # asdf
  . "$dotfiles__repos_dir/asdf/asdf.sh"

  # omz plugin: fzf
  # should be loaded after zsh-autocomplete because they use the same key bindings
  . "$dotfiles__repos_dir/ohmyzsh/plugins/fzf/fzf.plugin.zsh"
  zshrc::command_exists fzf || true # include fzf in missing commands if not found

  # omz plugin: ssh-agent
  zstyle :omz:plugins:ssh-agent agent-forwarding yes
  zstyle :omz:plugins:ssh-agent lazy yes
  zstyle :omz:plugins:ssh-agent lifetime 12h
  zstyle :omz:plugins:ssh-agent quiet yes
  . "$dotfiles__repos_dir/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh"

  # omz plugin: colored-man-pages
  autoload -Uz colors && colors
  . "$dotfiles__repos_dir/ohmyzsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh"

  # load pure prompt
  fpath+="$dotfiles__repos_dir/pure"
  autoload -Uz promptinit &&
    promptinit &&
    prompt pure

  # warn missing commands
  if [ -n "$dotfiles__missing_commands" ]; then
    zshrc::warn "missing commands: $(echo "$dotfiles__missing_commands" | sort | tr '\n' ' ')"
  fi

  # local zshrc overrides
  [ -f "$ZDOTDIR/.zshrc.local.zsh" ] && source "$ZDOTDIR/.zshrc.local.zsh"

  ~/.config/zsh/quote.zsh || true
}

### helpers

# check if command exists, but don't warn if not
function zshrc::command_exists_optional {
  command -v "$1" &>/dev/null
}

# check if command exists; if not, add to missing commands list
function zshrc::command_exists {
  if zshrc::command_exists_optional "$1"; then
    return 0
  else
    dotfiles__missing_commands+="$1"
    return 1
  fi
}

### logging

function zshrc::info {
  printf "\e[106m\e[30m[info ]\e[m \e[96m%s\e[m\n" "$*" >&2
}
function zshrc::warn {
  printf "\e[43m\e[30m[warn ]\e[m \e[33m%s\e[m\n" "$@" >&2
}
function zshrc::error {
  printf "\e[41m\e[30m[error]\e[m \e[31m%s\e[m\n" "$@" >&2
}

zshrc::init
