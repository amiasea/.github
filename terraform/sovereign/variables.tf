variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name."
  default     = "amiasea"
}

variable "hcp_project_name" {
  type = string
  default = "amiasea"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for all ARM-plane resources."
  default = "rg-amiasea"
}

variable "location" {
  type        = string
  description = "Azure region."
  default = "centralus"
}