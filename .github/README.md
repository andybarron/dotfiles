## Setup

1.  Install [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts).

1.  Create bare clone of repository.<br>

    ```shell
    git clone --bare git@github.com:andybarron/dotfiles.git $HOME/.tools/.repo

    # If SSH or credentials are unavailable, use HTTPS instead:
    # $ git clone --bare https://github.com/andybarron/dotfiles.git $HOME/.tools/.repo

    # Upgrade to SSH later:
    # $ GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git remote set-url origin git@github.com:andybarron/dotfiles.git
    ```

1.  Disable untracked file listing, so Git doesn't list everything under `$HOME`.

    ```shell
    GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git config --local status.showUntrackedFiles no
    ```

1.  Check out files.

    ```shell
    GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git checkout

    # In case of conflicts (e.g. if .zshrc already exists), overwrite with `--force`:
    # $ GIT_DIR=$HOME/.tools/.repo GIT_WORK_TREE=$HOME git checkout --force
    ```

1.  Let the games begin:
    ```shell
    source $HOME/.zshrc
    ```

## Links

- [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
