Adapted from: [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

```shell
git clone --mirror git@github.com:andybarron/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout # --force
source $HOME/.zshrc
```
