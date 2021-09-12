#!/usr/bin/env bash

{ # Prevent execution if this script was only partially downloaded
  set -e

  tmpfile=$(mktemp)
  trap 'rm $tmpfile' EXIT

  cat > "$tmpfile" <<'EOF'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'

  oops() {
    >&2 echo -e "${RED}error:${NC} $1"
    exit 1
  }

  API_OUTPUT=$(curl -sS https://api.github.com/repos/dapphub/dapptools/releases/latest)
  RELEASE=$(echo "$API_OUTPUT" | jq -r .tarball_url)

  [[ $RELEASE == null ]] && oops "No release found in ${API_OUTPUT}"

  cachix use dapp
  command -v solc >/dev/null || solc="solc"
  nix-env -iA dapp hevm seth ethsign "$solc" -f "$RELEASE"

  echo -e "${GREEN}All set!${NC}"
EOF

  nix-shell --pure -p cacert cachix curl git jq nix --run "bash $tmpfile"
} # End of wrapping

# vim: set ft=sh:

