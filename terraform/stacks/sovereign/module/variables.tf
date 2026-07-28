variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tfe_org_token" {
  type        = string
  description = "HCP Terraform organization token used by the sovereign platform."
  sensitive   = true
  # ephemeral   = true
}

variable "azure_tenant_id" {
  type = string
  ephemeral = true
}

variable "azure_subscription_id" {
  type = string
  ephemeral = true
}

variable "key_vault_name" {
  type        = string
  description = "Name of the sovereign, non-environment Key Vault."
  default     = "kv-amiasea"
}