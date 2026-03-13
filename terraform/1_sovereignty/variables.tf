variable "billing_account_id" {
  type        = string
  description = "The billing account ID to link the subscription to. This is required for new subscriptions created under an Enterprise Agreement (EA)."
  sensitive = true

  validation {
    # Validates the long MCA billing account format
    condition     = can(regex("^[a-z0-9-]+:[a-z0-9-]+_\\d{4}-\\d{2}-\\d{2}$", var.billing_account_id))
    error_message = "The billing_account_id must follow the MCA format (e.g., guid:guid_yyyy-mm-dd)."
  }
}

variable "billing_profile_id" {
  type        = string
  description = "The billing profile ID to link the subscription to. This is required for new subscriptions created under an Enterprise Agreement (EA)."
  sensitive = true

  validation {
    # Validates the 4-part alphanumeric profile ID
    condition     = can(regex("^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{3,4}-[A-Z0-9]{3,4}$", var.billing_profile_id))
    error_message = "The billing_profile_id must be a 4-part alphanumeric string (e.g., XXXX-XXXX-XXX-XXX)."
  }
}

variable "billing_profile_invoice_section_id" {
  type        = string
  description = "The billing profile invoice section ID to link the subscription to. This is required for new subscriptions created under an Enterprise Agreement (EA)."
  sensitive = true

  validation {
    condition     = can(regex("^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{3,4}-[A-Z0-9]{3,4}$", var.billing_profile_invoice_section_id))
    error_message = "The invoice_section_id must be a 4-part alphanumeric string."
  }
}

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
  description = "Resource group for all sovereign resources."
  default = "rg-amiasea"
}

variable "location" {
  type        = string
  description = "Azure region."
  default = "centralus"
}

variable "subscription_id" {
  type = string
  description = "Subscription ID."
}

variable "ghcr_pat" {
  type      = string
  ephemeral = true
}

variable "tf_token" {
  type      = string
  ephemeral = true
}

variable "amiasea_github_private_key" {
  type      = string
  ephemeral = true
}

variable "local_ip" {
  type = string
  sensitive = true
}