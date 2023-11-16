#!/bin/sh

# Function to execute when SIGTERM is received
handle_sigterm() {
    echo "SIGTERM received, shutting down..."
    rm -f /tmp/data/.ipc/${SUBNET_ID}/bootstrap.txt
    cd /app/fendermint
    exec cargo make--makefile ./infra/Makefile.toml bootstrap-down
    exit 0
}

# Start the bootstrap node
cd /app/fendermint
cargo make -e BASE_DIR=/tmp/data/.ipc/${SUBNET_ID} -e SUBNET_ID=${SUBNET_ID} --makefile ./infra/Makefile.toml \
     -e PRIVATE_KEY_PATH=${PRIVATE_KEY_PATH} \
     -e SUBNET_ID=${SUBNET_ID} \
     -e PARENT_REGISTRY=${PARENT_REGISTRY} \
     -e PARENT_GATEWAY=${PARENT_GATEWAY} \
     bootstrap

# Log the bootstrap id, as other services will need this
cargo make --makefile ./infra/Makefile.toml cometbft-node-id | grep -v cargo-make > /tmp/data/.ipc/${SUBNET_ID}/bootstrap.txt

# Keep running indefinitely
tail -f /dev/null

