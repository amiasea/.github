variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "client_id" {
  type        = string
  description = "Client ID of the sovereign UAMI (authority plane output)."
}

variable "principal_object_id" {
  type        = string
  description = "Object ID of the sovereign UAMI (authority plane output)."
}

variable "api_scope" {
  type        = string
  description = "Name of the API scope defined in the identity plane."
  default = "Airport.Control"
}