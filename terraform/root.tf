########################
# Configure the root CA #
########################

resource "vault_mount" "pki_root" {
  path                  = "/pki_root"
  type                  = "pki"
  max_lease_ttl_seconds = 315360000 // 10 years
}

resource "vault_pki_secret_backend_root_cert" "root" {
  backend     = vault_mount.pki_root.path
  type        = "internal"
  common_name = var.base_domain
  ttl         = "87600h" // 10 years
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates     = ["${var.vault_address}/v1/pki/ca"]
  crl_distribution_points = ["${var.vault_address}/v1/pki/crl"]
}
