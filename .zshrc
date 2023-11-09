# new machine setup:
# yadm clone git@github.com:andybarron/dotfiles.git

TOOLS_DIR="$HOME/tools"
ASDF_DIR="$TOOLS_DIR/asdf"
ASDF_INIT="$ASDF_DIR/asdf.sh"
ANTIDOTE_DIR="$TOOLS_DIR/antidote"
ANTIDOTE_INIT="$ANTIDOTE_DIR/antidote.zsh"
QUOTES_ROOT="$HOME/.quotes"

# quote of the day :)


if command -v fortune &> /dev/null; then
  quote_path() {
    local quote_dir="$QUOTES_ROOT/$(date +"%Y/%m/%d")"
    mkdir -p "$quote_dir"
    echo "$quote_dir/quote.txt"
  }

  quote() {
    local current_path=$(quote_path)
    if [[ ! -f "$current_path" ]]; then
      fortune -s > "$current_path"
    fi

    if command -v lolcat &> /dev/null; then
      cat "$current_path" | lolcat
    else
      cat "$current_path"
    fi
  }

  requote() {
    rm -f "$(quote_path)"
    quote
  }

  # [[ -f $(quote_path) ]] || quote
  quote
fi

# set up completions
autoload -Uz compinit && compinit

# update PATH for local binaries
export PATH="$HOME/.local/bin:$PATH"

# update fpath for zsh completions
fpath+=~/.zfunc

# set up directories
mkdir -p "$TOOLS_DIR"

# install asdf version manager
if [[ ! -f "$ASDF_INIT" ]]; then
  echo "downloading asdf"
  git clone --quiet --depth=1 https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
fi

# set up asdf
source "$ASDF_INIT"
fpath+="$ASDF_DIR/completions"

# install zsh plugin manager
if [[ ! -f "$ANTIDOTE_INIT" ]]; then
  echo "downloading antidote"
  git clone --quiet --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# set up zsh plugins
source "$ANTIDOTE_INIT"
antidote load "$ANTIDOTE_PLUGINS_FILE"

# init/install tools
if ! command -v zoxide &> /dev/null; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
eval "$(zoxide init zsh)"

# fun stuff
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

# aliases & functions
alias ls='ls --color=auto'
alias k='k -h'
