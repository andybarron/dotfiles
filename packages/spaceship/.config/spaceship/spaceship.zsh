SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_GIT_STATUS_PREFIX=' '
SPACESHIP_GIT_STATUS_SUFFIX=

# local env overrides
spaceship_local_override="$HOME/.config/spaceship/spaceship.local.zsh"
[ -f "$spaceship_local_override" ] && source "$spaceship_local_override"
unset spaceship_local_override
