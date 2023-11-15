Adapted from: [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

## Setup

```shell
# 1. create bare clone of repository:
git clone --bare git@github.com:andybarron/dotfiles.git $HOME/.tools/.repo

# if SSH or credentials are unavailable, use HTTPS instead:
# $ git clone --bare https://github.com/andybarron/dotfiles.git $HOME/.tools/.repo

# upgrade to SSH later if needed:
# $ GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git remote set-url origin git@github.com:andybarron/dotfiles.git

# 2. disable untracked file listing so git doesn't list everything under $HOME
GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git config --local status.showUntrackedFiles no

# 3. create all files
GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git checkout

# in case of conflicts (e.g. if .zshrc already exists), overwrite with `--force`:
# $ GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git checkout --force

# 4. let the games begin:
source $HOME/.zshrc
```
