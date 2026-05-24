variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "azure_oidc_token" {
    type = string
    sensitive = true
    ephemeral = true
}

variable "env_subscription_id" { type = string }

variable "sql_admins_group_id" {
  type = string
  description = "The Object ID of the Azure AD group that should be granted SQL admin permissions in the sovereign subscription."
}

variable "ghcr_pat_versionless_id" {
  type = string
  description = "GHCR PAT Key Vault Secret Versionless ID"
  sensitive = true
}

variable "sovereign_key_vault_id" {
  type = string
  description = "Sovereign Key Vault ID"
}

variable "api_image_tag" {
  type    = string
  default = "latest" # Or a "stable" tag like "v1"
}

variable "neon_project_id" {
    type = string
}