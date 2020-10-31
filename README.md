# Mutual TLS Demo

Run:
```
./setup-vault.sh docker
```
To run vault in docker and set it up as a CA using Terraform.

Then:
```
./gen-certs.sh docker
```
To generate TLS certificate for the server.

Finally:
```
docker-compose -f docker/docker-compose.yml up --build
```
Will build the client and server applications, then run them in docker.

The client calls a HTTPS endpoint on the server every second, with
Vault acting as the root certificate authority.

## ToDo
- [ ] Implement mutual TLS (currently only one-way)
- [ ] Add an intermediate CA
- [ ] Deploy in k8s
