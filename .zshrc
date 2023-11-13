# TODO: nerd font repo
function() {
  ROOT="$HOME/.tools"
  REPOS="$ROOT/repos"
  REPO="$ROOT/.repo"
  QUOTES="$ROOT/.quotes"

  # update PATH for local binaries e.g. pip installs
  export PATH="$HOME/.local/bin:$PATH"

  # configure default editor
  export VISUAL='vi'

  # utility functions
  function warn() {
    echo -e "\033[33m[WARN] $@\033[0m"
  }

  # quote of the day!
  if command -v fortune &> /dev/null; then
    quote_path() {
      local quote_dir="$QUOTES/$(date +"%Y/%m/%d")"
      mkdir -p "$quote_dir"
      echo "$quote_dir/quote.txt"
    }

    quote() {
      local current_path=$(quote_path)
      if [[ ! -f "$current_path" ]]; then
        fortune -s > "$current_path"
      fi

      command -v lolcat &> /dev/null && lolcat_cmd="lolcat" || lolcat_cmd="cat"
      command -v cowthink &> /dev/null && cow_cmd="cowthink -f ~/.fun/grogu.cow" || cow_cmd="cat"
      cat "$current_path" | eval $cow_cmd | eval $lolcat_cmd
    }

    requote() {
      rm -f "$(quote_path)"
      quote
    }

    [[ -f $(quote_path) ]] || quote
  fi

  # set up antidote (zsh plugin manager)
  zstyle ':antidote:bundle' use-friendly-names 'yes'
  source "$REPOS/antidote/antidote.zsh"
  antidote load

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
  fi

  # set up thefuck if found
  if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
  else
    missing_commands+='thefuck'
  fi

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
  else
    missing_commands+='nvim'
  fi
  alias vi='vim'

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
    warn "The following commands were not found: ${missing_commands[*]}"
  fi
}
