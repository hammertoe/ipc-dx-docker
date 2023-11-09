![IPC Localnode build status](https://github.com/hammertoe/ipc-dx-docker/actions/workflows/build.yaml/badge.svg)

# IPC Localnode

IPC Localnode is a Docker image that allows you to spin up a complete local standalone IPC node on your computer. You can use it to test IPC and to locally test deploying smart contracts

## System requirements

ARM64 (e.g. Macbook M1/M2s) or AMD64 (e.g. x86 Linux / Windows / MacOS).

## Prerequisites

Ensure you have [Docker installed](https://docs.docker.com/get-docker/). 

## Installation

**Please note**, that running the commands below will result in docker downloading a 3GB image on first run. So if you are going to be running this at somewhere with poor or metered internet connectivity, please be aware.

1. Clone this repository:

    ```sh
    git clone https://github.com/consensus-shipyard/ipc-dx-docker.git
    ```

1. Navigate to the repository:

    ```sh
    cd ipc-dx-docker
    ```

1. OPTIONAL: By default the subnet started will be `r0`. If you want a different subnet ID (also affects the chain ID), then you can either set the env variable `SUBNET_ID`, or edit it in the `.env` file.
    ```sh
    export SUBNET_ID=r42
    ```

1. To run a single IPC node (default): run Docker `compose up`:
    ```sh
    docker compose up
    ```

1. To stop the network run Docker `compose down`:
    ```sh
    docker compose down
    ```


## Metamask and Funding a Wallet

### Setting up Metamask

A default metamask wallet will be funded and the details show to you on startup:


```
############################
#                          #
# Testnode ready! 🚀       #
#                          #
############################

Eth API:
	http://0.0.0.0:8545

Accounts:
	t1vwjol3lvimayhxxvcr2fmbtr4dm2krsta4vxmvq: 1000000000000000000000 coin units
	t410f5joupqsfnfz2g2b5cakucfkigur2synrvem5d5q: 1000000000000000000000 coin units

Private key (hex ready to import in MetaMask):
	d870269696821eca9c628fe3780e8b54a5f471d29cc3cd444c9261d4d16e7730

Note: both accounts use the same private key @ /tmp/data/.ipc/r0/keys/validator_key.sk

Chain ID:
	0

Fendermint API:
	http://localhost:26658

CometBFT API:
	http://0.0.0.0:26657
```

You can configure metamask to connect to this local network by adding a new custom network, with the following steps:

1. Click the network at the top of Metamask
1. Click `Add a network manually` at the bottom
1. Enter the network information below

    ```
    Network name: IPC localnode
    New RPC URL: http://127.0.0.1:8545
    Chain ID: 3522868364964899
    Currency symbol: tFIL
    ```

### Funding a wallet

Your wallet will already be funded with 1000 tFIL, ready to use and deploy your first contract. To import the key into your Metamask wallet you will need to:

1. Click on the Metamask icon at the top of your browser
1. Click the accounts drop down at the top
1. Click `Add account or new hardware wallet`
1. Click `Import account`
1. Paste in the private key as shown in the output from starting the network
