variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name."
  default     = "amiasea"
}

variable "tfe_project_id" {
  type        = string
  description = "Terraform Cloud project ID for these workspaces."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for authority-plane resources."
}

variable "location" {
  type        = string
  description = "Azure region for authority-plane resources."
}