#!/bin/sh

# Create 3 new wallets
#if [ ! -z "$WALLET1_PRIVATE_KEY" ]; then
if [ -f /tmp/data/.ipc/priv_key1.txt ]; then
    wallet1=$(docker compose run ipc-cli wallet import -w evm --private-key $(cat /tmp/data/.ipc/priv_key1.txt) | tr -d '"')
else
    wallet1=$(docker compose run ipc-cli wallet new -w evm | tr -d '"')
fi

if [ -f /tmp/data/.ipc/priv_key2.txt ]; then
    wallet2=$(docker compose run ipc-cli wallet import -w evm --private-key $(cat /tmp/data/.ipc/priv_key2.txt) | tr -d '"')
else
    wallet2=$(docker compose run ipc-cli wallet new -w evm | tr -d '"')
fi

if [ -f /tmp/data/.ipc/priv_key3.txt ]; then
    wallet3=$(docker compose run ipc-cli wallet import -w evm --private-key $(cat /tmp/data/.ipc/priv_key3.txt) | tr -d '"')
else
    wallet3=$(docker compose run ipc-cli wallet new -w evm | tr -d '"')
fi

echo Wallet 1: $wallet1
echo Wallet 2: $wallet2
echo Wallet 3: $wallet3
echo

# Set the first wallet as the default wallet
echo Setting $wallet1 as default wallet address
docker compose run ipc-cli wallet set-default --address ${wallet1} -w evm
echo

# Check the balances and wait until topped up from the faucet
echo For each address above go send some funds to it at the faucet at:
echo https://faucet.calibration.fildev.network/funds.html
while true; do
    wallet_balances=$(docker compose run ipc-cli wallet balances --subnet /r314159 --wallet-type evm)
    my_wallet_balances=$(echo "$wallet_balances" | egrep "$wallet1|$wallet2|$wallet3" | sort)
    echo "$my_wallet_balances"

    if echo "$my_wallet_balances" | awk '{if ($4 <= 10) exit 1}'; then
	echo "All wallets are funded!"
	echo
	break
    else
	echo "Waiting on all wallets to be funded"
    fi

    echo
    sleep 15
done

echo "Creating the subnet"
output=$(docker compose run ipc-cli subnet create --parent /r314159 --min-validators 3 --min-validator-stake 1 --bottomup-check-period 30 2>&1)
subnet=$(echo "$output" | grep "created subnet actor with id:" | awk '{print $NF}')
echo "Subnet is: $subnet"
echo

# Get public keys for each wallet
echo "Getting public keys"
key1=$(docker compose run ipc-cli wallet pub-key -w evm --address $wallet1)
key2=$(docker compose run ipc-cli wallet pub-key -w evm --address $wallet2)
key3=$(docker compose run ipc-cli wallet pub-key -w evm --address $wallet3)
echo

# Joining subnets
echo "Joining subnets"
docker compose run ipc-cli subnet join --from=$wallet1 --subnet=$subnet --collateral=10 --public-key=$key1 --initial-balance 1
docker compose run ipc-cli subnet join --from=$wallet2 --subnet=$subnet --collateral=10 --public-key=$key2 --initial-balance 1
docker compose run ipc-cli subnet join --from=$wallet3 --subnet=$subnet --collateral=10 --public-key=$key3 --initial-balance 1
echo

# Export keys
echo "Exporting private keys"
docker compose run ipc-cli wallet export -w evm -a $wallet1 --hex -o /tmp/data/.ipc/priv_key1.txt
docker compose run ipc-cli wallet export -w evm -a $wallet2 --hex -o /tmp/data/.ipc/priv_key2.txt
docker compose run ipc-cli wallet export -w evm -a $wallet3 --hex -o /tmp/data/.ipc/priv_key3.txt
echo

echo "Subnet created: ${subnet}"
echo "Set the SUBNET_ID env variable, e.g: export SUBNET_ID=${subnet}"
echo "Edit your ~/.ipc/config.toml file to include your new subnet"
echo "To start a boostrap node run: docker compose up bootstrap"
echo "To start the validators run: docker compose up validator1 validator2 validator3"




    
