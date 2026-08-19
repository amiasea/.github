variable "organization_name" {
  type = string
  default = "amiasea"
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

variable "location" {
  description = "Azure region where the Key Vault will be deployed."
  type        = string
  default     = "centralus"
}