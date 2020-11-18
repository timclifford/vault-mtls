#!/usr/bin/env bash

set -e

if [[ $1 == "docker" ]]; then
  echo "Docker mode"
  SERVER_DOMAIN="mtls.docker"
  SERVER_COMMON_NAME="server.$SERVER_DOMAIN"
else
  echo "Localhost mode"
  SERVER_DOMAIN="localhost"
  SERVER_COMMON_NAME="$SERVER_DOMAIN"
fi

rm -f server/certs/*.pem
rm -f client/certs/*.pem

echo "Downloading root certificate..."
curl http://localhost:8200/v1/pki_root/ca/pem > server/certs/root.pem
cp server/certs/root.pem client/certs/root.pem

echo "Downloading intermediate certificate..."
CA_SIGNING_CERT=$( curl http://localhost:8200/v1/pki/ca/pem )

echo "Generating server certs..."
SERVER_OUTPUT=$( vault write "/pki/issue/server" \
    common_name="$SERVER_COMMON_NAME" \
    -format=json )

echo "$SERVER_OUTPUT" | jq -r .data.private_key > server/certs/key.pem
echo "$SERVER_OUTPUT" | jq -r .data.certificate > server/certs/cert.pem
echo "$CA_SIGNING_CERT" >> server/certs/cert.pem

echo "Generating client certs..."
CLIENT_OUTPUT=$( vault write "/pki/issue/client" \
    common_name="username@$SERVER_DOMAIN" \
    -format=json )

echo "$CLIENT_OUTPUT" | jq -r .data.private_key > client/certs/key.pem
echo "$CLIENT_OUTPUT" | jq -r .data.certificate > client/certs/cert.pem
echo "$CA_SIGNING_CERT" >> client/certs/cert.pem

echo "Done!"
