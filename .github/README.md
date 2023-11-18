## Setup

1.  Install [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts).

1.  Create bare clone of repository.<br>

    ```shell
    git clone --bare git@github.com:andybarron/dotfiles.git ~/.dotfiles/.gitbare
    ```

    ```shell
    # If SSH or credentials are unavailable, use HTTPS instead:
    # $ git clone --bare https://github.com/andybarron/dotfiles.git ~/.dotfiles/.gitbare

    # Upgrade to SSH later:
    # $ git --git-dir=~/.dotfiles/.gitbare remote set-url origin git@github.com:andybarron/dotfiles.git
    ```

1.  Check out files.

    ```shell
    git --git-dir=~/.dotfiles/.gitbare --work-tree=~ checkout
    ```

    ```shell
    # In case of conflicts (e.g. if .zshrc already exists), overwrite with `--force`:
    # $ git --git-dir=~/.dotfiles/.gitbare --work-tree=~ checkout --force
    ```

1.  Let the games begin:
    ```shell
    exec zsh
    ```

## Links

- [atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
- [Pure prompt buggy prompt characters](https://github.com/sindresorhus/pure/issues/561)
