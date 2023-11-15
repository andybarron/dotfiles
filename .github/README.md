## Setup

1.  Install [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts).

1.  Create bare clone of repository.<br>

    ```shell
    git clone --bare git@github.com:andybarron/dotfiles.git ~/.tools/.repo.git
    ```

    ```shell
    # If SSH or credentials are unavailable, use HTTPS instead:
    # $ git clone --bare https://github.com/andybarron/dotfiles.git ~/.tools/.repo.git

    # Upgrade to SSH later:
    # $ GIT_DIR=~/.tools/.repo.git GIT_WORK_TREE=~ git remote set-url origin git@github.com:andybarron/dotfiles.git
    ```

1.  Check out files.

    ```shell
    GIT_DIR=~/.tools/.repo.git GIT_WORK_TREE=~ git checkout
    ```

    ```shell
    # In case of conflicts (e.g. if .zshrc already exists), overwrite with `--force`:
    # $ GIT_DIR=~/.tools/.repo.git GIT_WORK_TREE=~ git checkout --force
    ```

1.  Let the games begin:
    ```shell
    source ~/.zshrc
    ```

## Links

- [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
- [Pure prompt buggy prompt characters](https://github.com/sindresorhus/pure/issues/561)
