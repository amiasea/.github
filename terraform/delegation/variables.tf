# Azure

ephemeral "tfe_outputs" "accession" {
  organization = var.organization_name
  workspace    = "accession"
}

variable "organization_name" {
  description = "The name of the organization."
  type        = string
  default     = "amiasea"
}

variable "location" {
  description = "Azure region where the Key Vault will be deployed."
  type        = string
  default     = "centralus"
}

variable "authority_azure_tenant_id" {
  type = string
}

variable "authority_azure_client_id" {
  type = string
}

variable "sovereign_azure_subscription_id" {
  type = string
}

variable "sovereign_azure_resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "sovereign_azure_key_vault_name" {
  description = "Name of the Sovereign Azure Key Vault."
  type        = string
}

# AWS

# GCP
