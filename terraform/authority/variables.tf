variable "tenant_id" {
  description = "Azure AD tenant ID associated with the Key Vault."
  type        = string
}

variable "subscription_id" {
  type = string
}

variable "location" {
  description = "Azure region where the Key Vault will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
}

variable "amiasea_tfe_org_token" {
  description = "Amiasea TFE Organizational Token"
  type        = string
}

variable "amiasea_github_app_private_key" {
  description = "Amiasea GitHub App Private Key"
  type        = string
}