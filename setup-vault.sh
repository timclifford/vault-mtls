#!/usr/bin/env bash

set -e

docker-compose --file docker/docker-compose.yml up --detach --scale client=0 --scale server=0

export VAULT_ADDR=http://localhost:8200
until vault login dev-root-token; do
  sleep 1
done

cd terraform
rm *.tfstate *.tfstate.backup
terraform init
terraform apply -auto-approve
