#!/bin/false
# shellcheck shell=sh

# check if the current POSIX shell is interactive
# https://unix.stackexchange.com/a/26827

[ -n "${RC__SOURCE_CHECK_INTERACTIVE:-""}" ] && return 0

case "$-" in
  *i*)
  ;;
  *) return 1
  ;;
esac

RC__SOURCE_CHECK_INTERACTIVE=1
