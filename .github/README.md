```zsh
git clone --bare git@github.com:andybarron/dotfiles.git $HOME/.dotfiles
git config --local status.showUntrackedFiles no --git-dir=$HOME/.dotfiles
git checkout --git-dir=$HOME/.dotfiles
source $HOME/.zshrc
```
