variable "resource_group_name" {
  type        = string
  description = "Resource group for all ARM-plane resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "uami_read_id" {
  type        = string
  description = "ID of the user-assigned managed identity with read permissions."
}

variable "uami_read_client_id" {
  type        = string
  description = "Client ID of the user-assigned managed identity with read permissions."
}

variable "uami_read_principal_id" {
  type        = string
  description = "Object ID of the user-assigned managed identity with read permissions."
}

variable "uami_write_principal_id" {
  type        = string
  description = "Object ID of the user-assigned managed identity with write permissions."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID for the authority resources."
}