# Andy's dotfiles

## Setup

### Required installation commands

- [`git`](https://git-scm.com)
- [`stow`](https://www.gnu.org/software/stow)

### Required usage commands

_These are technically optional, but some features will be disabled, and zsh
will print warnings on startup._

- [`fzf`](https://github.com/junegunn/fzf)
- [`lsd`](https://github.com/lsd-rs/lsd)
- [`nvim`](https://neovim.io/)
- [`zoxide`](https://github.com/ajeetdsouza/zoxide)

## Installation

```sh
git clone --recurse-submodules -j4 git@github.com:andybarron/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/sync && exec zsh -i
```
