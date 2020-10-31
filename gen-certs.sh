#!/usr/bin/env bash

set -e

mkdir -p server/certs
mkdir -p client/certs

curl http://localhost:8200/v1/pki/ca/pem > client/certs/root.pem

SERVER_OUTPUT=$( vault write /pki/issue/localhost \
    common_name=localhost \
    -format=json )

echo "$SERVER_OUTPUT" | jq -r .data.private_key > server/certs/key.pem
echo "$SERVER_OUTPUT" | jq -r .data.certificate > server/certs/cert.pem
