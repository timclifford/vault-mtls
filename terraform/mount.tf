resource "vault_mount" "pki" {
  path                  = "/pki"
  type                  = "pki"
  max_lease_ttl_seconds = 315360000 // 10 years
}
