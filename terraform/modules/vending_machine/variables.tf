variable "location" {
  type        = string
  default     = "centralus"
  description = "Azure region for resource deployment."
}

variable "prefix" {
  type        = string
  description = "Prefix"
  default = "amiasea"
}

variable "domain" {
  type = string
  description = "domain"
  default = "amiasea.com"
}

variable "env" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)."

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "The environment variable must be either 'dev' or 'prod'."
  }
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
  sensitive = true
}

variable "sovereign_key_vault_id" {
  type = string
  description = "Sovereign Key Vault ID"
}

variable "api_image_tag" {
  type        = string
  description = "The  Git tag string natively passed from the stack execution context"

  # Enforce strict platform validation gates
  validation {
    # 1. Condition: Ensure the tag is not empty AND starts with your exact prefix
    condition     = var.api_image_tag != "" && startswith(var.api_image_tag, "api-v")
    
    # 2. Hard Failure Message: Thrown immediately in the Stack UI logs if violated
    error_message = "The api_image_tag input variable must be a valid, non-empty release tag string beginning with the 'api-v' prefix."
  }
}

variable "neon_project_id" {
    type = string
}