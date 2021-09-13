# DDapptools, aka Docker-Dapptools
A docker version of the 💊 of solidity development.

The container lives [here](https://hub.docker.com/r/odyslam/ddapptools) on DockerHub.

## Instructions

The docker image is a drop-in replacement for [dapptools](https://github.com/dapphub/dapptools).It's best to use the original dapptools and use the container image only if NIX is not playing nicely with your system.

In order for the container to function as a drop-in replacement, it must do 3 things:
- Have access to the same `env` context as the dev machine
- Have access to the files in the directory from which it's invoked
- Use the same command without having to mess with docker internals

To satisfy all 3 requirements, I created `ddapp.sh` which is a helper script that  manages everything for you.

Instead of running `dapp` or `seth`, you run `ddapp.sh seth` or `ddapp.sh dapp` and it's the same thing. With every invocation, it will do the following things:
- Create a container from the `odyslam/ddapptools` image
- Mount the `$(pwd)` directory to that container
- Source the `$(env)` of the dev machine inside the container
- Source the `.env` file of the current directory inside the container. (This might become more flexible in the future).
- Delete the container after use

**Disclaimer:**
You are advised to read the Dockerfile and all the scripts that come in the repository before running everything. It's better to assume a bad actor and do the extra work.

### Example

If you use [gakonst/dapptools-template](https://github.com/gakonst/dapptools-template) as the basis for your project, simply:
- Clone this repository (odyslam/ddapptools) to your dev machine. Let's say you clone it in `~/code/ddapptools`.
- `cd` into the`dapptools-template` directory
- run `~/code/ddapptools/scripts/ddapp.sh make test`
- profit

You can now use `dapptools` without having to install them. Since the local directory is mounted inside the container, the `Makefile` is mounted as well. Inside the container, `dapp` is installed, thus no further change is required from us.

## Contributing

Yes, please. Preferably using the Gitflow workflow.

## License

MIT

## TODO

- [x] Install dapptools in container
- [x] create drop-in replacement container as CLI for dapptools
- [ ] create full-fledged devenv that user can ssh into and develop
