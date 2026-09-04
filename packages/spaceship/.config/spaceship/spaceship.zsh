SPACESHIP_PROMPT_PREFIXES_SHOW=false

# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
# if `...` async loading icon hangs forever, add this to a local override:
# SPACESHIP_ASYNC_SHOW=false

function {
  spaceship_local_override="$HOME/.config/spaceship/spaceship.$(hostname).zsh"
  [ -f "$spaceship_local_override" ] && source "$spaceship_local_override"
  unset spaceship_local_override
}
