setopt interactive_comments

# https://www.danielmoch.com/posts/2018/11/zsh-compinit-rtfm
# for profiling: un-comment following line, then run zprof
# zmodload zsh/zprof

function () {
  local ROOT="$HOME/.tools"
  local REPOS="$ROOT/.repos"
  local REPO="$ROOT/.repo.git"
  local QUOTES="$ROOT/.quotes"
  local FUN="$ROOT/fun"
  local ANTIDOTE_DIR="$REPOS/antidote"
  local ANTIDOTE_INIT="$ANTIDOTE_DIR/antidote.zsh"
  local GIT_EMAIL_BASE64="YW5keWJhcnJvbkBwcm90b25tYWlsLmNvbQo="

  local -A GIT_OPTIONS
  GIT_OPTIONS=(
    [user.name]="Andy Barron"
    [init.defaultbranch]="main"
    [push.autoSetupRemote]="true"
    [commit.verbose]="true"
  )

  local -A CUSTOM_ALIASES
  CUSTOM_ALIASES=(
    # git
    g 'git'
    # git add
    ga 'git add'
    gaa 'git add --all'
    # git branch
    gb 'git branch'
    gbd 'git branch --delete'
    gbm 'git branch --move'
    # git commit
    gc 'git commit'
    gca 'git commit --all'
    gcam 'git commit --all --message'
    gcm 'git commit --message'
    # git diff
    gd 'git diff'
    gds 'git diff --staged'
    # git log
    gl 'git log'
    glo 'git log --oneline'
    # git status
    gst 'git status'
    # git switch
    gsw 'git switch'
    gswc 'git switch -c'
    # git pull
    gl 'git pull'
    # git push
    gp 'git push'
    gpf 'git push --force-with-lease'
    # git misc helpers
    gundo 'git reset HEAD~1'
    gredo 'git commit --reuse-message=ORIG_HEAD'
    # ls(d?)
    l 'ls'
    la 'l -A'
    ll 'l -l'
    lt 'l --tree'
    lal 'l -Al'
    lat 'l -A --tree'
    llt 'l -l --tree'
    lalt 'l -Al --tree'
    # dotfile management
    dotfiles "GIT_DIR=$REPO GIT_WORK_TREE=$HOME"
    undotfiles 'unset GIT_DIR GIT_WORK_TREE'
    dtf 'dotfiles'
    undtf 'undotfiles'
    # misc
    grep '\grep --color=auto'
  )

  # utility functions
  function zshrc::info() {
    echo -e "\e[106m\e[30m[info]\e[m \e[96m$@\e[m" >&2
  }
  function zshrc::warn() {
    echo -e "\e[43m\e[30m[warn]\e[m \e[33m$@\e[m" >&2
  }
  function zshrc::error() {
    echo -e "\e[41m\e[30m[error]\e[m \e[31m$@\e[m" >&2
  }
  function zshrc::git_set_if_unset() {
    if [[ -z $(git config --global --get "$1") ]]; then
      git config --global "$1" "$2"
    fi
  }
  function zshrc::command_exists() {
    command -v "$1" &> /dev/null
  }

  # set git config (if not already set)
  if zshrc::command_exists base64; then
    GIT_OPTIONS+=(
      [user.email]="$(base64 --decode <<< "$GIT_EMAIL_BASE64")"
    )
  fi
  for key value in ${(kv)GIT_OPTIONS}; do
    zshrc::git_set_if_unset "$key" "$value"
  done

  # quote of the day!
  if zshrc::command_exists fortune; then
    zshrc__quotes_root="$QUOTES"
    zshrc__cow_path="$FUN/grogu.cow"
    zshrc::quote_path() {
      local quote_dir="${zshrc__quotes_root}/$(date +"%Y/%m/%d")"
      mkdir -p "$quote_dir"
      echo "$quote_dir/quote.txt"
    }

    zshrc::quote() {
      local current_path=$(zshrc::quote_path)
      if [[ ! -f "$current_path" ]]; then
        fortune -s > "$current_path"
      fi

      zshrc::command_exists lolcat && lolcat_cmd="lolcat" || lolcat_cmd="cat"
      zshrc::command_exists cowthink && cow_cmd="cowthink -f $zshrc__cow_path" || cow_cmd="cat"
      cat "$current_path" | eval $cow_cmd | eval $lolcat_cmd
    }

    zshrc::requote() {
      rm -f "$(zshrc::quote_path)"
      zshrc::quote
    }

    [[ -f $(zshrc::quote_path) ]] || zshrc::quote
  fi

  # set up antidote (zsh plugin manager)
  zstyle ':antidote:bundle' use-friendly-names 'yes'
  if [[ ! -f "$ANTIDOTE_INIT" ]]; then
    zshrc::info "Installing antidote..."
    git clone https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
  fi
  source "$ANTIDOTE_INIT"
  antidote load

  # fix invisible zsh comments:
  # https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
  ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'

  # set prompt
  autoload -Uz promptinit && promptinit && prompt pure

  # track missing commands for warning
  missing_commands=()

  # set up zsh completions
  mkdir -p ~/.zfunc
  fpath+=~/.zfunc

  if zshrc::command_exists rustup; then
    [[ ! -f ~/.zfunc/_rustup ]] && rustup completions zsh > ~/.zfunc/_rustup
    [[ ! -f ~/.zfunc/_cargo ]] && rustup completions zsh cargo > ~/.zfunc/_cargo
  fi

  # set up zoxide if found
  if zshrc::command_exists zoxide; then
    eval "$(zoxide init zsh)"
  else
    missing_commands+="zoxide"
    alias z='\cd'
  fi

  # # set up thefuck if found
  # # TODO: broken due to https://github.com/nvbn/thefuck/issues/1372
  # if zshrc::command_exists thefuck; then
  #   eval $(thefuck --alias)
  # else
  #   missing_commands+='thefuck'
  # fi

  # set up lsd if found
  if zshrc::command_exists lsd; then
    alias ls='\lsd --date=relative'
  else
    missing_commands+='lsd'
    alias ls='\ls -h --color=auto'
  fi

  # set up nvim if found
  if zshrc::command_exists nvim; then
    alias vim='\nvim'
    export VISUAL=nvim
  else
    missing_commands+='nvim'
    export VISUAL=vim
  fi
  alias vi='vim'
  alias v='vim'

  # set up aliases
  for key value in ${(kv)CUSTOM_ALIASES}; do
    alias "$key"="$value"
  done
  # git: fetch latest default branch, rebase into current branch, and safely force push
  function gsync() {
    local remote=$(git remote || zshrc::error "Could not find git remote" && return 1)
    local default_branch=$(basename $(git symbolic-ref refs/remotes/origin/HEAD)) || zshrc::error "Could not find git default branch" && return 1
    git fetch "$remote" "$default_branch" && git rebase "$remote/$default_branch" && git push --force-with-lease
  }

  # ensure dotfiles git config is synced
  eval "dotfiles git config --local include.path '../.gitconfig'"

  # alert on missing commands
  if [[ ${#missing_commands[@]} -ne 0 ]]; then
    zshrc::warn "The following commands were not found: ${missing_commands[*]}"
  fi
}
