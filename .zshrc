# new machine setup:
# yadm clone --recurse-submodules git@github.com:andybarron/dotfiles.git && exec $SHELL

TOOLS_DIR="$HOME/.tool-repos"
ASDF_DIR="$TOOLS_DIR/asdf"
ASDF_INIT="$ASDF_DIR/asdf.sh"
ANTIDOTE_INIT="$TOOLS_DIR/antidote/antidote.zsh"
VIM_PLUG="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
QUOTES_ROOT="$HOME/.quotes"

# update PATH for local binaries e.g. pip installs
export PATH="$HOME/.local/bin:$PATH"

# set up zsh completions
mkdir -p ~/.zfunc
fpath+=~/.zfunc

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
    command -v cowthink &> /dev/null && cow_cmd="cowthink -f ~/.fun/grogu.cow" || cow_cmd="cat"
    cat "$current_path" | eval $cow_cmd | eval $lolcat_cmd
  }

  requote() {
    rm -f "$(quote_path)"
    quote
  }

  [[ -f $(quote_path) ]] || quote
fi

# track things to install
desired_tools=(fzf nvim thefuck)
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
  alias vi=vim
fi

# set up completions
autoload -Uz compinit && compinit

# set up asdf tool version manager
source "$ASDF_INIT"
fpath+="$ASDF_DIR/completions"

# set up antidote zsh plugin manager
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

# set up thefuck
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

# aliases & functions
alias ls='\ls --color=auto'
