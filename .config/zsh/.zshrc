dotfiles__root_dir="$HOME/.dotfiles"
dotfiles__repos_dir="$HOME/.tool_repos"

dotfiles__git_dir="$dotfiles__root_dir/.gitbare"
dotfiles__scripts_dir="$dotfiles__root_dir/scripts"

dotfiles__missing_commands=()
dotfiles__repos=(
  "https://github.com/mattmc3/antidote.git"
)

dotfiles__zdotdir="${ZDOTDIR:-$HOME}"

function zshrc::init {
  # configure zsh options
  HISTFILE="$dotfiles__zdotdir/.zsh_history"
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
  git config --global include.path "~/.dotfiles/default.gitconfig"

  # load zoxide
  if zshrc::command_exists zoxide; then
    eval "$(zoxide init zsh)"
  fi

  # clone repos for various tools
  for repo_url in $dotfiles__repos; do
    zshrc::git_clone "$repo_url"
  done

  # set up EDITOR variable
  if zshrc::command_exists nvim; then
    export VISUAL=nvim
    alias v=nvim
  else
    export VISUAL=vim
    alias v=vim
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

  alias gparent="$dotfiles__scripts_dir/git_parent"
  alias gsync="$dotfiles__scripts_dir/git_sync"

  # ls aliases
  alias la='l -A'
  alias ll='l -l'
  alias lt='l --tree'
  alias lal='l -Al'
  alias lat='l -A --tree'
  alias llt='l -l --tree'
  alias lalt='l -Al --tree'

  # dotfile repo aliases
  # TODO: do this without polluting env if no command is passed
  alias dotfiles='GIT_DIR="$dotfiles__git_dir" GIT_WORK_TREE="$HOME"'
  alias undotfiles='unset GIT_DIR GIT_WORK_TREE'
  alias dtf='dotfiles'
  alias undtf='undotfiles'

  # other aliases
  alias grep='command grep --color=auto'
  alias tm='tmux new -As0 || tmux'

  # set up zsh plugins
  zstyle :antidote:bundle use-friendly-names yes

  zstyle :omz:plugins:ssh-agent agent-forwarding yes
  zstyle :omz:plugins:ssh-agent lazy yes
  zstyle :omz:plugins:ssh-agent lifetime 12h
  zstyle :omz:plugins:ssh-agent quiet yes

  source "$dotfiles__repos_dir/antidote/antidote.zsh"
  antidote load

  # https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
  # ZSH_HIGHLIGHT_STYLES[comment]="fg=8,bold"

  # load pure prompt
  autoload -Uz promptinit && promptinit && prompt pure

  # warn missing commands
  if [ -n "$dotfiles__missing_commands" ]; then
    zshrc::warn "missing commands: $(echo "$dotfiles__missing_commands" | sort | uniq | tr '\n' ' ')"
  fi

  # local zshrc overrides
  [ -f "$HOME/.override.zshrc" ] && source "$HOME/.override.zshrc"
}

### helpers

# check if command exists, but don't warn if not
function zshrc::command_exists_optional {
  command -v "$1" >/dev/null 2>&1
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

# clone git repository URL to directory matching repository name,
# it no such directory exists
function zshrc::git_clone {
  local git_repo_name="$(basename "$1" .git)"
  local git_repo_path="$dotfiles__repos_dir/$git_repo_name"
  if [ ! -d "$git_repo_path" ]; then
    zshrc::info "cloning: $1"
    mkdir -p "$dotfiles__repos_dir"
    if ! git clone "$1" "$git_repo_path"; then
      zshrc::error "clone failed: $1"
    fi
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
