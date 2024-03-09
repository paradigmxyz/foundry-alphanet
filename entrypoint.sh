#!/bin/bash

FOUNDRY_COMMAND="$1"
SOLC_PATH="--use /usr/local/bin/solc"
FOUNDRY_DIRECTORY="--root $2"
FOUNDRY_SCRIPT="$3"

if [ "$FOUNDRY_COMMAND" = "script" ] && [ -z "$FOUNDRY_SCRIPT" ]; then
  echo "Error: 'foundry-script' is required when 'foundry-command' is 'script'"
  exit 1
fi

if [ "$FOUNDRY_COMMAND" = "script" ]; then
  exec forge script $FOUNDRY_SCRIPT $SOLC_PATH $FOUNDRY_DIRECTORY --fork-url http://localhost:8545 --broadcast -vvvv
else
  exec forge $FOUNDRY_COMMAND $SOLC_PATH $FOUNDRY_DIRECTORY
fi
