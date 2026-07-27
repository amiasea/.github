variable "key_vault_name" {
  type        = string
  description = "Name of the sovereign Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the sovereign Key Vault."
}

variable "secret_name" {
  type        = string
  description = "Name of the Key Vault secret to retrieve."
}