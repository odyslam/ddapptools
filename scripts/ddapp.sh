#!/bin/bash
# set -e
docker run -it --env "$(env | grep -v 'NIX|TERM')" --name dapptools --mount type="bind",source="$(pwd)",target=/dapptools dapptools:latest source .env $@
docker stop dapptools > /dev/null
docker rm dapptools > /dev/null
