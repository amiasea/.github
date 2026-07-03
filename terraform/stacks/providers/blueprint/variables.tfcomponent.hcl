variable "azure_oidc_token" {
  type        = string
  sensitive   = true
  ephemeral   = true
  description = "Dynamic runtime JSON Web Token supplied natively by HCP Stacks identity blocks."
}

variable "tfe_org_name" {
  type        = string
  default     = "amiasea"
  description = "The target corporate HCP Terraform organization workspace prefix name."
}

variable "provider_names" {
  type        = list(string)
  description = "The comprehensive list array string matrix of custom provider targets to provision across systems."
}

# --- Shared Bootstrap Varset Inherited Parameter Fields ---
variable "sovereign_azure_tenant_id" {
  type      = string
  sensitive = true
}

variable "sovereign_azure_subscription_id" {
  type      = string
  sensitive = true
}

variable "sovereign_azure_client_id" {
  type      = string
  sensitive = true
}

variable "amiasea_gh_app_id" {
  type        = string
  description = "The Master Organization GitHub Application Client Identifier configuration parameter."
}