#!/bin/sh

cd /app/fendermint
exec cargo make -e BASE_DIR=/tmp/data/.ipc/${SUBNET_ID} -e SUBNET_ID=${SUBNET_ID} --makefile ./infra/Makefile.toml $@
