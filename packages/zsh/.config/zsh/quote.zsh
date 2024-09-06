#!/usr/bin/env zsh
set -euo pipefail

command -v jq &>/dev/null || exit

cached_quote_dir="$HOME/.cache/qotd"
cached_quote_file="$cached_quote_dir/quote"

mkdir -p "$cached_quote_dir"

function refresh_quote {
  json=$(curl -sfm 5 https://zenquotes.io/api/today)
  if [[ -z "$json" ]]; then
    return 1
  fi
  quote=$(echo "$json" | jq -r '.[0].q')
  author=$(echo "$json" | jq -r '.[0].a')
  text=$(echo "$quote\n~ $author" | fold -sw 60)
  if command -v lolcat &>/dev/null; then
    text=$(echo "$text" | lolcat -f --seed=$(date "+%Y%m%d"))
  fi
  header="\e[3mzenquotes.io QOTD\e[0m"
  full="$header\n\n$text"
  echo "$full" >"$cached_quote_file"
}

if [[ ! -f "$cached_quote_file" ]] || [[ $(find "$cached_quote_file" -mmin +60) ]]; then
  refresh_quote &>/dev/null || true
fi

if [[ -f "$cached_quote_file" ]]; then
  cat "$cached_quote_file"
fi
