#!/bin/bash
# set -e

# Create a new container from the image, pass all env variables of the dev machine into the container,
# and finally execute the passed commands/arguments inside the container.
# Note that the current working directory is mounted inside the container, in the directory "$HOME/dapptools".
# That directory is the WORKDIR that is defined in Dockerfile, thus the commands will be executed inside the container,
# but in the workdir of the dev machine from where the `docker run` command was invoked.
# This is what enables the container to be a drop-in replacement of the `dapp` command.
# Read more about `docker run`: https://docs.docsocker.com/engine/reference/commandline/run/

 BINDED_VOLUMES="--mount type=bind,source=$(pwd),target=/dapptools"
if [[ -e ${ETH_KEYSTORE} ]];then
  BINDED_VOLUMES="$BINDED_VOLUMES --mount type=bind,source='${ETH_KEYSTORE}',target=/.ethereum/keystore"
else
  if [[ -e $HOME/Library/Ethereum/keystore ]]; then
    BINDED_VOLUMES="${BINDED_VOLUMES} --mount type=bind,source=$HOME/Library/Ethereum/keystore,target=/root/.ethereum/keystore"
  elif [[ -e $HOME/.ethereum/keystore  ]]; then
    BINDED_VOLUMES="${BINDED_VOLUMES} --mount type=bind,source=$HOME/library/ethereum/keystore,target=/root/.ethereum/keystore"
  fi
fi
echo $BINDED_VOLUMES
docker run -it --env "$(env | grep -ve 'HOME' -e 'NIX' -e 'TERM' -e 'SSH' -e 'PATH')" --name ddapptools $BINDED_VOLUMES odyslam/ddapptools:latest "$@"
# Stop container and remove it. This is required so that we can `docker run` the same image but with a new argument (thus a new container)
# output of the commands is silenced
docker stop ddapptools > /dev/null
docker rm ddapptools > /dev/null
