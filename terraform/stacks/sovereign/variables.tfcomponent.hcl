variable "sovereign_azure_subscription_id" {
  type = string
  ephemeral = true
}

variable "sovereign_azure_tenant_id" {
  type = string
  ephemeral = true
}

variable "sovereign_azure_client_id" {
  type = string
  ephemeral = true
}

variable "azure_oidc_token" {
  type = string
  ephemeral = true
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