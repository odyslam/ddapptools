# DDapptools, aka Docker-Dapptools
[![DockerHub Publish CI](https://github.com/OdysLam/ddapptools/actions/workflows/docker-publish.yml/badge.svg?branch=main)](https://github.com/OdysLam/ddapptools/actions/workflows/docker-publish.yml)

A docker version of the 💊 of solidity development.

The container lives [here](https://hub.docker.com/r/odyslam/ddapptools) on DockerHub.

## Instructions

The docker image is a drop-in replacement for [dapptools](https://github.com/dapphub/dapptools).

In order for the container to function as a drop-in replacement, it must do 3 things:
- Have access to the same `env` context as the dev machine
- Have access to the files in the directory from which it's invoked
- Use the same command without having to mess with docker internals

To satisfy all 3 requirements, we run:

```bash
if [[ -e ".env" ]];then
  SOURCE_COMMAND="source .env"
else
  SOURCE_COMMAND=""
fi
docker run -it --env "$(env | grep -v 'NIX|TERM')" --name ddapptools --mount type="bind",source="$(pwd)",target=/dapptools odyslam/ddapptools:latest $SOURCE_COMMAND && $@
docker stop ddapptools > /dev/null
docker rm ddapptools > /dev/null
```
The above commands:
- Create a container from the `odyslam/ddapptools` image
- Mount the `$(pwd)` (the current) directory to that container
- Delete the container after use

These commands have been packaged into `ddapp.sh`. To invoke `seth` we run `ddapp.sh seth`.


### Example

If you use [gakonst/dapptools-template](https://github.com/gakonst/dapptools-template) as the basis for your project:
- Clone this repository (odyslam/ddapptools) to your dev machine. Let's say you clone it in `~/code/ddapptools`.
- `cd` into the`dapptools-template` directory
- run `~/code/ddapptools/scripts/ddapp.sh make test`
- Deploy the contract and test it with `~/code/ddapptools/scripts/ddapp.sh seth send 0x42... "Greeter(uint256)" 345`

## Troubleshooting

**Mounting directories with Docker Desktop**

If you use Docker Desktop, there are settings regarding the directories that you allow docker to mount to containers. You can read more about this on [Docker's documentation](https://docs.docker.com/desktop/), in the `user manual` of the platform that you are using (Windows/MacOS/Linux).

**Hardware wallet support**

- Linux: It should be supported, due to the `--privileged` flag that is used to run the container. **It hasn't been tested**.
- MacOS: **It's not supported**. This is because currently Docker Desktop for Mac [does not support USB passthrough](https://github.com/docker/for-mac/issues/900). The container simply can't see the usb devices.
- Windows: Unknown

**Ethsign keystores**

`ddapp.sh` will automatically mount the default keystore directories that `ethsign` uses, if they are detected to exist. That means that the dev machine and the `ddapptools container` will share the same keystores that will persist between subsequent runs of `ddapp.sh` as they are stored on the dev machine, via the container.

It will mount the first keystore that is detected, with the following order:
- Detect $ETH_KEYSTORE env variable
- Detect existence of `$HOME/Library/Ethereum/keystore`
- Detect existence of `$HOME/.ethereum/keystore`

The directory will be mounted inside the container at the following directory: `/root/.ethereum/keystore`.

## Contributing

Yes

## License

MIT
