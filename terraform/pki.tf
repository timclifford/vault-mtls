resource "vault_pki_secret_backend_root_cert" "root" {
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = var.base_domain
  ttl         = "87600h" // 10 years
}

resource "vault_pki_secret_backend_role" "localhost_role" {
  backend          = vault_mount.pki.path
  name             = replace(var.base_domain, ".", "-")
  max_ttl          = "72h"
  allowed_domains  = [var.base_domain]
  allow_subdomains = true
}
