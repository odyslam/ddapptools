#!/bin/bash
set -e
# set defaults

# The following commands idles the container so that the user can "ssh" into it
# tail -f /dev/null

# Removed   [[ "$(id -u)" -eq 0 ]] && oops "Please run this script as a regular user"
# Our setup runs nix as root. Original file: https://dapp.tools/install

if [[ "$1" == "idle" ]]; then
  tail -f /dev/null
else
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"  &&  "$@"
fi

