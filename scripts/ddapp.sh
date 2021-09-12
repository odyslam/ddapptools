#!/bin/bash
# set -e

# Create a new container from the image, pass all env variables of the dev machine into the container,
# and finally execute the passed commands/arguments inside the container.
# Note that the current working directory is mounted inside the container, in the directory "$HOME/dapptools".
# That directory is the WORKDIR that is defined in Dockerfile, thus the commands will be executed inside the container,
# but in the workdir of the dev machine from where the `docker run` command was invoked.
# This is what enables the container to be a drop-in replacement of the `dapp` command.
# Read more about `docker run`: https://docs.docker.com/engine/reference/commandline/run/

if [[ -e ".env" ]];then
  SOURCE_COMMAND="source .env"
else
  SOURCE_COMMAND=""
fi
docker run -it --env "$(env | grep -v 'NIX|TERM')" --name ddapptools --mount type="bind",source="$(pwd)",target=/dapptools odyslam/ddapptools:latest $SOURCE_COMMAND && $@
# Stop container and remove it. This is required so that we can `docker run` the same image but with a new argument (thus a new container)
# output of the commands is silenced
docker stop ddapptools > /dev/null
docker rm ddapptools > /dev/null
