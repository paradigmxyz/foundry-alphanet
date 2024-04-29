#!/bin/bash

main() {
    local FOUNDRY_COMMAND=""
    local FOUNDRY_DIRECTORY=""
    local FOUNDRY_SCRIPT=""
    local SOLC_PATH="--use /usr/local/bin/solc"

    # Parse named arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --foundry-command) FOUNDRY_COMMAND="$2"; shift ;;
            --foundry-directory) FOUNDRY_DIRECTORY="--root $2"; shift ;;
            --foundry-script) FOUNDRY_SCRIPT="$2"; shift ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done

    if [ "$FOUNDRY_COMMAND" = "script" ] && [ -z "$FOUNDRY_SCRIPT" ]; then
        echo "Error: 'foundry-script' is required when 'foundry-command' is 'script'"
        exit 1
    fi

    if [ "$FOUNDRY_COMMAND" = "script" ]; then
        exec forge script $FOUNDRY_SCRIPT $SOLC_PATH $FOUNDRY_DIRECTORY --fork-url http://localhost:8545 --broadcast -vvvv
    else
        if [[ "$FOUNDRY_COMMAND" =~ ^forge ]]; then
            exec $FOUNDRY_COMMAND $SOLC_PATH $FOUNDRY_DIRECTORY
        elif [[ "$FOUNDRY_COMMAND" =~ ^anvil ]]; then
            exec $FOUNDRY_COMMAND --host 0.0.0.0 --hardfork prague
        fi
        echo "Error: 'foundry-command' only supports 'forge' or 'anvil' binaries"
        exit 1
    fi
}

main "${@}"
