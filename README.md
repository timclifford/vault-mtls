# Mutual TLS Demo

## Running in Docker
```
./setup-vault.sh docker
```
To run vault in docker and set it up as a CA using Terraform.

Then:
```
./gen-certs.sh docker
```
To generate TLS certificates for the client and server, and to download the CA's 
root certificate.

Finally:
```
docker-compose up --build
```
Will build the client and server applications, then run them in docker.

The client calls a HTTPS endpoint on the server every second, with
Vault acting as the root certificate authority.

## Running natively
To run natively on your machine, run the same first 2 commands above but without 
the `docker` argument.

In one terminal window, run:
```
cd server
go run main.go
```
to start the server. Then start the client in another terminal window with:
```
cd client
MTLS_SERVER=https://localhost:8443 go run main.go
```

## ToDo
- [x] Implement mutual TLS (currently only one-way)
- [x] Add an intermediate CA
- [ ] Deploy in k8s
