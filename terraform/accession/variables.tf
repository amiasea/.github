variable "location" {
  type = string
}

variable "authority_azure_tenant_id" {
  description = "Azure AD tenant ID associated with the Key Vault."
  type        = string
}

# TODO: This should come from the subscription defined in this module
variable "sovereign_azure_subscription_id" {
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