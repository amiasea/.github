variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "key_vault_name" {
  type        = string
  description = "Name of the sovereign, non-environment Key Vault."
  default     = "kv-amiasea"
}

variable "tfe_org_token" {
  type = string
}