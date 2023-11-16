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

  # utility functions
  function zshrc::info() {
    echo -e "\e[106m\e[30m[warn]\e[m \e[96m$@\e[m"
  }
  function zshrc::warn() {
    echo -e "\e[43m\e[30m[info]\e[m \e[33m$@\e[m"
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
  declare -A GIT_OPTIONS
  GIT_OPTIONS+=(
    [user.name]="Andy Barron"
    [init.defaultbranch]="main"
    [push.autoSetupRemote]="true"
    [commit.verbose]="true"
  )
  if zshrc::command_exists base64; then
    GIT_OPTIONS+=(
      [user.email]="$(base64 --decode <<< "YW5keWJhcnJvbkBwcm90b25tYWlsLmNvbQo=")"
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
  # TODO: cargo, rustup completions

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
    alias l='\lsd --date=relative'
  else
    missing_commands+='lsd'
    alias l='\ls -h --color=auto'
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

  # aliases: ls/lsd
  alias ls='\ls --color=auto'

  alias la='l -A'
  alias ll='l -l'
  alias lt='l --tree'
  alias lal='l -Al'
  alias lat='l -A --tree'
  alias llt='l -l --tree'
  alias lalt='l -Al --tree'

  # aliases: dotfile management
  alias dotfiles="GIT_DIR=$REPO GIT_WORK_TREE=$HOME"
  alias undotfiles='unset GIT_DIR GIT_WORK_TREE'
  alias dtf='dotfiles'
  alias undtf='undotfiles'

  # aliases: misc
  alias grep="grep --color=auto"

  # alert on missing commands
  if [[ ${#missing_commands[@]} -ne 0 ]]; then
    zshrc::warn "The following commands were not found: ${missing_commands[*]}"
  fi
}
