#!/usr/bin/env bash

set -e

if [[ $1 == "docker" ]]; then
  echo "Docker mode"
  DOMAIN="mtls.docker"
  VAULT_ADDRESS="http://vault.mtls.docker:8200"
else
  echo "Localhost mode"
  DOMAIN="localhost"
  VAULT_ADDRESS="http://localhost:8200"
fi

docker-compose --file docker/docker-compose.yml up --detach --scale client=0 --scale server=0

export VAULT_ADDR=http://localhost:8200
until vault login dev-root-token; do
  sleep 1
done

cd terraform
rm -f *.tfstate *.tfstate.backup
terraform init
terraform apply \
  -var base_domain=$DOMAIN \
  -var vault_address=$VAULT_ADDRESS \
  -auto-approve
