variable "key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
  default       = "kv-amiasea"
}

variable "location" {
  description = "Azure region where the Key Vault will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID associated with the Key Vault."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default     = {}
}

variable "amiasea_tfe_org_token" {
  description = "Amiasea TFE Organizational Token"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "amiasea_github_app_private_key" {
  description = "Amiasea GitHub App Private Key"
  type        = string
  sensitive   = true
  ephemeral   = true
}
