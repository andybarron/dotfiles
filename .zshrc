setopt interactive_comments

# https://www.danielmoch.com/posts/2018/11/zsh-compinit-rtfm
# for profiling: un-comment following line, then run zprof
# zmodload zsh/zprof

function() {
  local ROOT="$HOME/.tools"
  local REPOS="$ROOT/repos"
  local REPO="$ROOT/.repo"
  local QUOTES="$ROOT/.quotes"
  local FUN="$ROOT/fun"
  local ANTIDOTE_DIR="$REPOS/antidote"
  local ANTIDOTE_INIT="$ANTIDOTE_DIR/antidote.zsh"

  # update PATH for local binaries e.g. pip installs
  export PATH="$HOME/.local/bin:$PATH"

  # utility functions
  function zshrc__info() {
    echo -e "\e[106m\e[30m[warn]\e[m \e[96m$@\e[m"
  }
  function zshrc__warn() {
    echo -e "\e[43m\e[30m[info]\e[m \e[33m$@\e[m"
  }

  # quote of the day!
  if command -v fortune &> /dev/null; then
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

      command -v lolcat &> /dev/null && lolcat_cmd="lolcat" || lolcat_cmd="cat"
      command -v cowthink &> /dev/null && cow_cmd="cowthink -f $zshrc__cow_path" || cow_cmd="cat"
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
    zshrc__info "Installing antidote..."
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
  if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
  else
    missing_commands+="zoxide"
    alias z='\cd'
  fi

  # # set up thefuck if found
  # # TODO: broken due to https://github.com/nvbn/thefuck/issues/1372
  # if command -v thefuck &> /dev/null; then
  #   eval $(thefuck --alias)
  # else
  #   missing_commands+='thefuck'
  # fi

  # set up lsd if found
  if command -v lsd &> /dev/null; then
    alias l='\lsd --date=relative'
  else
    missing_commands+='lsd'
    alias l='\ls -h --color=auto'
  fi

  # set up nvim if found
  if command -v nvim &> /dev/null; then
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

  # alert on missing commands
  if [[ ${#missing_commands[@]} -ne 0 ]]; then
    zshrc__warn "The following commands were not found: ${missing_commands[*]}"
  fi
}
