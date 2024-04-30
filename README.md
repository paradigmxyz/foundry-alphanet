# foundry-alphanet

Tools built around the patched versions of revm, forge, and the solidity compiler from
[anton-rs/3074-invokers], which support [EIP-3074] instructions.

We intend to further roll out Foundry patches to support other EVM modifications such as
new opcodes or precompiles.

## Docker image

The Docker image defined in this repo contains both the patched solc and forge
binaries, compatible with EIP-3074 and ready to be used. The patches are avaiable
under the `patches` directory, during the image build process the source for
both binaries is checked out, the patches are applied and the binaries are built
and put under `/usr/local/bin` in the final image.

The image also includes an entrypoint script that makes it easier to use the
patched forge with any foundry project using EIP-3074 instructions. It provides
these arguments:
* `--foundry-command`: subcommand to use with the patched forge
* `--foundry-directory`: where to find the foundry project in the container
* `--foundry-script`: when `--foundry-command` is script, path in the foundry
project of the script to execute.

There's a github actions workflow in this repo that builds and publishes the
image on each merge to main, it is available at: `ghcr.io/paradigmxyz/foundry-alphanet`

### How to use
Containers created from this image should mount a local directory containing a
source foundry project and then run a forge command on it. For example, to
build a project, from the project root you can execute:
```shell
$ docker run --rm \
    -v $(pwd):/app/foundry \
    -u $(id -u):$(id -g) \
    ghcr.io/paradigmxyz/foundry-alphanet:latest \
    --foundry-directory /app/foundry \
    --foundry-command "forge build"
```
In this command:
* `-v $(pwd):/app/foundry` mounts the local directory in `/app/foundry` in the
container.
* `-u $(id -u):$(id -g)` makes sure that the files created will belong to the
same user executing the command.
* `ghcr.io/paradigmxyz/foundry-alphanet:latest` is the image name
* `--foundry-directory /app/foundry` tells the entrypoint script to use
`/app/foundry` in the container as the foundry project directory.
* `--foundry-command "forge build"` tells the entrypoint script to use `forge build` as the
foundry command.

To run tests in a project, from the projects root:
```shell
$ docker run --rm \
    -v $(pwd):/app/foundry \
    -u $(id -u):$(id -g) \
    ghcr.io/paradigmxyz/foundry-alphanet:latest \
    --foundry-directory /app/foundry \
    --foundry-command "forge test -vvv"
```

In this case we have signalled forge that we want increased verbosity in the test
output passing `forge test -vvvv` to `--foundry-command`.

To run Anvil:

```shell
$ docker run --rm \
    -v $(pwd):/app/foundry \
    -u $(id -u):$(id -g) \
    -p 8545:8545 \
    ghcr.io/paradigmxyz/foundry-alphanet:latest \
    --foundry-command "anvil"
```

[anton-rs/3074-invokers]: https://github.com/anton-rs/3074-invokers
[EIP-3074]: https://eips.ethereum.org/EIPS/eip-3074
