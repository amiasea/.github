variable "billing_email" {
  type = string
}

variable "billing_account_id" {
  type        = string
  description = "Azure billing account scope."
  sensitive   = true
}

variable "billing_profile_id" {
  type        = string
  description = "Azure billing profile."
  sensitive   = true
}

variable "billing_profile_invoice_section_id" {
  type        = string
  description = "Azure billing profile invoice section."
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Entra tenant ID."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID used to establish the sovereign platform."
  sensitive   = true
}

variable "organization_name" {
  type        = string
  description = "Amiasea organization name."
  default     = "amiasea"
}

variable "location" {
  type        = string
  description = "Azure region for sovereign bootstrap resources."
  default     = "centralus"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the sovereign, non-environment Key Vault."
  default     = "kv-amiasea"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing sovereign bootstrap resources."
  default     = "rg-amiasea"
}

variable "github_app_private_key" {
  type        = string
  description = "Private key for the Amiasea GitHub App."
  sensitive   = true
  ephemeral   = true
}

variable "tfe_org_token" {
  type        = string
  description = "HCP Terraform organization token used by the sovereign platform."
  sensitive   = true
  # ephemeral   = true
}