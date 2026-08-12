variable "location" {
  type = string
}

variable "sovereign_azure_resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "sovereign_azure_key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
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