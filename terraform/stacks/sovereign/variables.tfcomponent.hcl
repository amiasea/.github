variable "sovereign_azure_subscription_id" {
  type = string
}

variable "sovereign_azure_tenant_id" {
  type = string
}

variable "sovereign_azure_client_id" {
  type = string
}

variable "azure_oidc_token" {
  type = string
}

variable "key_vault_name" {
  type        = string
  description = "Name of the sovereign, non-environment Key Vault."
  default     = "kv-amiasea"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}