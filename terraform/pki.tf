resource "vault_pki_secret_backend_root_cert" "root" {
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = var.base_domain
  ttl         = "87600h" // 10 years
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates     = ["${var.vault_address}/v1/pki/ca"]
  crl_distribution_points = ["${var.vault_address}/v1/pki/crl"]
}

resource "vault_pki_secret_backend_role" "localhost_role" {
  backend          = vault_mount.pki.path
  name             = replace(var.base_domain, ".", "-")
  max_ttl          = "72h"
  allowed_domains  = [var.base_domain]
  allow_subdomains = true
}
