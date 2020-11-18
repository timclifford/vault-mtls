################################
# Configure the intermediate CA #
################################

resource "vault_mount" "pki_intermediate" {
  path                  = "/pki"
  type                  = "pki"
  max_lease_ttl_seconds = 157680000 // 5 years
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_request" {
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "${var.base_domain} Intermediate Authority"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "signed_intermediate" {
  backend     = vault_mount.pki_root.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.intermediate_request.csr
  common_name = vault_pki_secret_backend_intermediate_cert_request.intermediate_request.common_name
}

resource "vault_pki_secret_backend_intermediate_set_signed" "set_signed" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.signed_intermediate.certificate
}

resource "vault_pki_secret_backend_role" "server_role" {
   backend = vault_mount.pki_intermediate.path
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
   backend = vault_mount.pki_intermediate.path
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
