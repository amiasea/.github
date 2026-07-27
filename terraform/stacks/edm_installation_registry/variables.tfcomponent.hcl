variable "installations" {
  type = map(object({
    github_organization = string
    tfe_organization    = string
  }))
}

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

variable "azure_oidc_token" {
  type        = string
  sensitive   = true
  ephemeral   = true
  description = "Dynamic runtime JSON Web Token supplied natively by HCP Stacks identity blocks."
}

variable "amiasea_gh_app_id" {
    type      = string
}