#!/bin/bash
set -e
# set defaults

# The following commands idles the container so that the user can "ssh" into it
# tail -f /dev/null

# If container is called with "idle" as first argument, then Idle.
# Else source nix.sh and pass to bash all arguments (command + argument) to the container

if [[ "$1" == "idle" ]]; then
  tail -f /dev/null
else
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"  &&  "$@"
fi

