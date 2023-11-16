#!/bin/sh

# Function to execute when SIGTERM is received
handle_sigterm() {
    echo "SIGTERM received, shutting down..."
    exit 0
}

BOOTSTRAP_ID="$(cat /tmp/data/.ipc/${SUBNET_ID}/bootstrap.txt)@127.0.0.1:26655"

# Start the validator node
cd /app/fendermint
cargo make -e BASE_DIR=/tmp/data/.ipc/${SUBNET_ID} -e SUBNET_ID=${SUBNET_ID} --makefile ./infra/Makefile.toml \
     -e PRIVATE_KEY_PATH=${PRIVATE_KEY_PATH} \
     -e SUBNET_ID=${SUBNET_ID} \
     -e BOOTSTRAPS=${BOOTSTRAP_ID} \
     -e PARENT_REGISTRY=${PARENT_REGISTRY} \
     -e PARENT_GATEWAY=${PARENT_GATEWAY} \
     child-validator

# Keep running indefinitely
tail -f /dev/null

