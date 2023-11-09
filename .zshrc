TOOLS_DIR="$HOME/tools"
ASDF_DIR="$TOOLS_DIR/asdf"
ASDF_INIT="$ASDF_DIR/asdf.sh"
ANTIDOTE_DIR="$TOOLS_DIR/antidote"
ANTIDOTE_INIT="$ANTIDOTE_DIR/antidote.zsh"
QUOTES_ROOT="$HOME/.quotes"

# aliases & functions
alias ls='ls --color=auto'

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

# fun stuff
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

if command -v fortune &> /dev/null; then
  quote_path() {
    local quote_dir="$QUOTES_ROOT/$(date +"%Y/%m/%d")"
    mkdir -p "$quote_dir"
    echo "$quote_dir/quote.txt"
  }

  quote() {
    local current_path=$(quote_path)
    if [[ ! -f "$current_path" ]]; then
      fortune -s computers food linux love wisdom > "$current_path"
    fi

    if command -v lolcat &> /dev/null; then
      cat "$current_path" | lolcat
    else
      cat "$current_path"
    fi
  }

  if [[ ! -f $(quote_path) ]]; then
    quote
  fi
fi
