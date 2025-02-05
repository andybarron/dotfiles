SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_GIT_STATUS_PREFIX=' '
SPACESHIP_GIT_STATUS_SUFFIX=

# temporary workaround
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
SPACESHIP_ASYNC_SYMBOL=''

# local env overrides
spaceship_local_override="$HOME/.config/spaceship/spaceship.local.zsh"
[ -f "$spaceship_local_override" ] && source "$spaceship_local_override"
unset spaceship_local_override
