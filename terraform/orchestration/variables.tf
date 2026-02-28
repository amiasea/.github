variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name."
  default     = "amiasea"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for authority-plane resources."
}

variable "location" {
  type        = string
  description = "Azure region for authority-plane resources."
}