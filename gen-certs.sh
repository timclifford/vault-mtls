#!/usr/bin/env bash

set -e

if [[ $1 == "docker" ]]; then
  echo "Docker mode"
  ROLE_NAME="mtls-docker"
  SERVER_COMMON_NAME="server.mtls.docker"
  CLIENT_COMMON_NAME="client.mtls.docker"
else
  echo "Localhost mode"
  ROLE_NAME="localhost"
  SERVER_COMMON_NAME="localhost"
  CLIENT_COMMON_NAME="localhost"
fi

rm -f server/certs/*.pem
rm -f client/certs/*.pem

curl http://localhost:8200/v1/pki/ca/pem > server/certs/root.pem
cp server/certs/root.pem client/certs/root.pem

SERVER_OUTPUT=$( vault write "/pki/issue/$ROLE_NAME" \
    common_name="$SERVER_COMMON_NAME" \
    -format=json )

echo "$SERVER_OUTPUT" | jq -r .data.private_key > server/certs/key.pem
echo "$SERVER_OUTPUT" | jq -r .data.certificate > server/certs/cert.pem

CLIENT_OUTPUT=$( vault write "/pki/issue/$ROLE_NAME" \
    common_name="$CLIENT_COMMON_NAME" \
    -format=json )

echo "$CLIENT_OUTPUT" | jq -r .data.private_key > client/certs/key.pem
echo "$CLIENT_OUTPUT" | jq -r .data.certificate > client/certs/cert.pem
