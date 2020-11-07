resource "vault_mount" "pki" {
  path                  = "/pki"
  type                  = "pki"
  max_lease_ttl_seconds = 315360000 // 10 years
}

resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = var.base_domain
  ttl         = "87600h" // 10 years
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["${var.vault_address}/v1/pki/ca"]
  crl_distribution_points = ["${var.vault_address}/v1/pki/crl"]
}

resource "vault_pki_secret_backend_role" "server_role" {
  backend = vault_mount.pki.path
  name    = "server"
  max_ttl = "72h"

  allowed_domains    = [var.base_domain]
  allow_any_name     = false
  allow_glob_domains = true
  allow_ip_sans      = true
  allow_subdomains   = true
  enforce_hostnames  = true

  client_flag = false
  server_flag = true
}

resource "vault_pki_secret_backend_role" "client_role" {
  backend = vault_mount.pki.path
  name    = "client"
  max_ttl = "72h"

  allowed_domains    = [var.base_domain]
  allow_any_name     = false
  allow_bare_domains = true // Required for email addresses
  allow_glob_domains = false
  allow_ip_sans      = true
  allow_subdomains   = false
  enforce_hostnames  = true

  client_flag = true
  server_flag = false
}
