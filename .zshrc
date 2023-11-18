setopt interactive_comments
bindkey -e

#   local -A CUSTOM_ALIASES
#   CUSTOM_ALIASES=(
#     # git
#     g 'git'
#     # git add
#     ga 'git add'
#     gaa 'git add --all'
#     # git branch
#     gb 'git branch'
#     gbd 'git branch --delete'
#     gbm 'git branch --move'
#     # git commit
#     gc 'git commit'
#     gca 'git commit --all'
#     gcam 'git commit --all --message'
#     gcm 'git commit --message'
#     # git diff
#     gd 'git diff'
#     gds 'git diff --staged'
#     # git log
#     gl 'git log'
#     glo 'git log --oneline'
#     # git status
#     gst 'git status'
#     # git switch
#     gsw 'git switch'
#     gswc 'git switch -c'
#     # git pull
#     gl 'git pull'
#     # git push
#     gp 'git push'
#     gpf 'git push --force-with-lease'
#     # git misc helpers
#     gundo 'git reset HEAD~1'
#     gredo 'git commit --reuse-message=ORIG_HEAD'
#     # ls(d?)
#     l 'ls'
#     la 'l -A'
#     ll 'l -l'
#     lt 'l --tree'
#     lal 'l -Al'
#     lat 'l -A --tree'
#     llt 'l -l --tree'
#     lalt 'l -Al --tree'
#     # dotfile management
#     dotfiles "GIT_DIR=$REPO GIT_WORK_TREE=$HOME"
#     undotfiles 'unset GIT_DIR GIT_WORK_TREE'
#     dtf 'dotfiles'
#     undtf 'undotfiles'
#     # misc
#     grep '\grep --color=auto'
#   )

#   # attach/start zellij if installed and ZELLIJ_ATTACH is set
#   # (rest of file will be sourced within zellij)
#   if [[ ! -z "$ZELLIJ_ATTACH" ]]; then
#     if zshrc::command_exists zellij; then
#       [[ -z "$ZELLIJ" ]] && (zellij attach -c default) && exit
#     else
#       missing_commands+='zellij'
#     fi
#   fi

#   # quote of the day!
#   if zshrc::command_exists fortune; then
#     zshrc__quotes_root="$QUOTES"
#     zshrc__cow_path="$FUN/grogu.cow"
#     zshrc::quote_path() {
#       local quote_dir="${zshrc__quotes_root}/$(date +"%Y/%m/%d")"
#       mkdir -p "$quote_dir"
#       echo "$quote_dir/quote.txt"
#     }

#     zshrc::quote() {
#       local current_path=$(zshrc::quote_path)
#       if [[ ! -f "$current_path" ]]; then
#         fortune -s > "$current_path"
#       fi

#       zshrc::command_exists lolcat && lolcat_cmd="lolcat" || lolcat_cmd="cat"
#       zshrc::command_exists cowthink && cow_cmd="cowthink -f $zshrc__cow_path" || cow_cmd="cat"
#       cat "$current_path" | eval $cow_cmd | eval $lolcat_cmd
#     }

#     zshrc::requote() {
#       rm -f "$(zshrc::quote_path)"
#       zshrc::quote
#     }

#     [[ -f $(zshrc::quote_path) ]] || zshrc::quote
#   fi

#   # set prompt
#   autoload -Uz promptinit && promptinit && prompt pure

#   # set up zsh completions
#   mkdir -p ~/.zfunc
#   fpath+=~/.zfunc

#   if zshrc::command_exists rustup; then
#     [[ ! -f ~/.zfunc/_rustup ]] && rustup completions zsh > ~/.zfunc/_rustup
#     [[ ! -f ~/.zfunc/_cargo ]] && rustup completions zsh cargo > ~/.zfunc/_cargo
#   fi

#   # set up zoxide if found
#   if zshrc::command_exists zoxide; then
#     eval "$(zoxide init zsh)"
#   else
#     missing_commands+="zoxide"
#     alias z='\cd'
#   fi

#   # # set up thefuck if found
#   # # TODO: broken due to https://github.com/nvbn/thefuck/issues/1372
#   # if zshrc::command_exists thefuck; then
#   #   eval $(thefuck --alias)
#   # else
#   #   missing_commands+='thefuck'
#   # fi

#   # set up lsd if found
#   if zshrc::command_exists lsd; then
#     alias ls='\lsd --date=relative'
#   else
#     missing_commands+='lsd'
#     alias ls='\ls -h --color=auto'
#   fi

#   # set up nvim if found
#   if zshrc::command_exists nvim; then
#     alias vim='\nvim'
#     export VISUAL=nvim
#   else
#     missing_commands+='nvim'
#     export VISUAL=vim
#   fi
#   alias vi='vim'
#   alias v='vim'


source "$RC__SOURCE/interactive"

# source ~/.tools/scripts/exec-fish.sh

zmodload zsh/zprof

fpath+="$RC__REPOS/asdf/completions"

if rc__command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

"$RC__SCRIPTS/warn-missing"

autoload -Uz compinit && compinit
