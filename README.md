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
These commands have been packaged into `ddapp.sh`. To invoke `seth` we run `ddapp.sh seth`.

It's a helper script that does the following:

- Creates a container from the `odyslam/ddapptools` image
- Mounts the `$(pwd)` (the current) directory to that container
- Deletes the container after use

### Example

If you use [gakonst/dapptools-template](https://github.com/gakonst/dapptools-template) as the basis for your project:
- Clone this repository (odyslam/ddapptools) to your dev machine. Let's say you clone it in `~/code/ddapptools`.
- `cd` into the`dapptools-template` directory
- run `~/code/ddapptools/scripts/ddapp.sh make test`
- Deploy the contract and test it with `~/code/ddapptools/scripts/ddapp.sh seth send 0x42... "Greeter(uint256)" 345`

## Troubleshooting

**Mounting directories with Docker Desktop**

If you use Docker Desktop, there are settings regarding the directories that you allow docker to mount to containers. You can read more about this on [Docker's documentation](https://docs.docker.com/desktop/), in the `user manual` of the platform that you are using (Windows/MacOS/Linux).


## Contributing

Yes

## License

MIT

## TODO

- [x] Install dapptools in container
- [x] create drop-in replacement container as CLI for dapptools
- [ ] create full-fledged devenv that user can ssh into and develop
