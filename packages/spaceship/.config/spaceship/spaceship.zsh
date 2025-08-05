SPACESHIP_PROMPT_PREFIXES_SHOW=false

function {
  spaceship_local_override="$HOME/.config/spaceship/spaceship.$(hostname).zsh"
  [ -f "$spaceship_local_override" ] && source "$spaceship_local_override"
  unset spaceship_local_override
}
