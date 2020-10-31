#!/usr/bin/env bash

set -e

if [[ $1 == "docker" ]]; then
  echo "Docker mode"
  ROLE_NAME="mtls-docker"
  COMMON_NAME="mtls.docker"
else
  echo "Localhost mode"
  ROLE_NAME="localhost"
  COMMON_NAME="localhost"
fi

mkdir -p server/certs

SERVER_OUTPUT=$( vault write "/pki/issue/$ROLE_NAME" \
    common_name="server.$COMMON_NAME" \
    -format=json )

echo "$SERVER_OUTPUT" | jq -r .data.private_key > server/certs/key.pem
echo "$SERVER_OUTPUT" | jq -r .data.certificate > server/certs/cert.pem
