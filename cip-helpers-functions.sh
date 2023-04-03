#!/bin/env bash

# Log management function
function _log() {
  echo $*
}

# Error management function
function _err() {
  _log "ERROR: $*"
}

function vault_load_key_in_env() {
    if [ -z "$1" ]; then
        _err "Please provide vault key name"
    else
        vaultKey=$1

        # Pulling data from the Vault
        JSON_OBJ=$(vault kv get -format json $VAULT_MOUNT/$VAULT_TOP_DIR/$vaultKey | jq '.data.data | del(.[".onyxia"])')

        # Exporting keys and corresponding values as environment variables
        for key in $(echo $JSON_OBJ | jq -r 'keys[]'); do export "$key=$(echo $JSON_OBJ | jq -r ".$key")"; done
    fi
}
