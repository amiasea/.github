variable "location" {
  type        = string
  description = "Azure region for resource deployment."
}

variable "prefix" {
  type        = string
  description = "Prefix"
  default = "amiasea"
}

variable "env" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)."

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be either 'dev' or 'prod'."
  }
}

variable "sovereign_billing_scope_id" {
  type        = string
  description = "Billing Scope ID for the sovereign subscription."
}

variable "role_definition_id" {
  type        = string
  description = "Role Definition ID to assign to the UAMI in the new subscription."
}

variable "api_scope" {
  type        = string
  description = "The scope of the API permissions to grant to the UAMI"
  default = "access_as_user"
}

variable "sql_admins_group_id" {
  type = string
  description = "The Object ID of the Azure AD group that should be granted SQL admin permissions in the sovereign subscription."
}

variable "ghcr_pat_versionless_id" {
  type = string
  description = "GHCR PAT Key Vault Secret Versionless ID"
}