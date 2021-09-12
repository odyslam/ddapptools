#!/bin/bash
set -e
# set defaults

# The following commands idles the container so that the user can "ssh" into it
# tail -f /dev/null

# script will have to source "$HOME/.nix-profile/etc/profile.d/nix.sh" for every "shell" session"

if [[ "$1" == "idle" ]]; then
  tail -f /dev/null
else
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"  &&  "$@"
fi

