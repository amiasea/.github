variable "resource_group_name" {
  type        = string
  description = "Resource group for all ARM-plane resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

# variable "sovereign_tfe_token" {
#   type        = string
#   description = "Terraform Cloud token with permissions to the sovereign workspace."
# }

variable "umai_read_id" {
  type        = string
  description = "ID of the user-assigned managed identity with read permissions."
}

variable "uami_read_principal_id" {
  type        = string
  description = "Object ID of the user-assigned managed identity with read permissions."
}

variable "umai_write_id" {
  type        = string
  description = "ID of the user-assigned managed identity with write permissions."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID for the authority resources."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for the authority resources."
}