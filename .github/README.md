Adapted from: [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

```shell
git clone --mirror git@github.com:andybarron/dotfiles.git $HOME/.tools/.repo
git --git-dir=$HOME/.tools/.repo config --local status.showUntrackedFiles no
git --git-dir=$HOME/.tools/.repo --work-tree=$HOME checkout # --force
source $HOME/.zshrc
```
