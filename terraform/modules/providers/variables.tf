variable "tfe_org_name" {
  type        = string
  default     = "amiasea"
  description = "The target HCP Terraform organization name."
}

variable "provider_names" {
  type        = list(string)
  description = "List of raw provider names to scaffold"
}