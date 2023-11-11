# new machine setup:
# yadm clone git@github.com:andybarron/dotfiles.git

TOOLS_DIR="$HOME/.ztools"
ASDF_DIR="$TOOLS_DIR/asdf"
ASDF_INIT="$ASDF_DIR/asdf.sh"
ANTIDOTE_DIR="$TOOLS_DIR/antidote"
ANTIDOTE_INIT="$ANTIDOTE_DIR/antidote.zsh"
VIM_PLUG="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
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

    command -v lolcat &> /dev/null && lolcat_cmd="lolcat" || lolcat_cmd="cat"
    command -v cowthink &> /dev/null && cowthink_cmd="cowthink -f small -e 'Oo'" || cowthink_cmd="cat"
    cat "$current_path" | eval $cowthink_cmd | eval $lolcat_cmd
  }

  requote() {
    rm -f "$(quote_path)"
    quote
  }

  # [[ -f $(quote_path) ]] || quote
  quote
fi

# track things to install
desired_tools=(fzf nvim thefuck yadm)
missing_tools=()

for tool in "${desired_tools[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    missing_tools+=("$tool")
  fi
done

# alert on missing tools
if [[ ${#missing_tools[@]} -ne 0 ]]; then
  echo -e "\n\033[33mThe following commands are missing: ${missing_tools[*]}\033[0m"
fi

# set up editor prefs
if command -v nvim &> /dev/null; then
  export EDITOR=nvim
  alias vim=nvim
  alias vi=nvim
else
  export EDITOR=vim
fi

# set up completions
autoload -Uz compinit && compinit

# update PATH for local binaries
export PATH="$HOME/.local/bin:$PATH"

# set up zsh completions
mkdir -p ~/.zfunc
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

# set up vim-plug
if [[ ! -f "$VIM_PLUG" ]]; then
  echo "downloading vim-plug"
  curl -sSfLo "$VIM_PLUG" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# set up zoxide
if ! command -v zoxide &> /dev/null; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
eval "$(zoxide init zsh)"

if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

# aliases & functions
alias ls='ls --color=auto'
alias k='k -h'
