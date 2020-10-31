variable "base_domain" {
    type        = string
    description = "Base domain to use"
    default     = "localhost"
}

variable "vault_address" {
    type        = string
    description = "Address the vault server is accessible at by services"
    default     = "http://127.0.0.1:8200"
}
