variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name."
  default     = "amiasea"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault to create for the sovereign."
  default     = "kv-amiasea"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for all ARM-plane resources."
  default = "rg-amiasea"
}

variable "location" {
  type        = string
  description = "Azure region."
  default = "centralus"
}

variable "aviator_gh_app_id" {
  type        = string
  description = "Client ID of the Aviator application registered in Azure AD."
  default = "2670685"
}

variable "aviator_private_key_name" {
  type        = string
  description = "Private key for the Amiasea GitHub App."
  default     = "amiasea-github-private-key"
}