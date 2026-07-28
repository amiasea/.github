variable "organization_name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "environments" {
  type = list(string)
  description = "Environments"
  default = ["dev", "prod"]
}

variable "domain" {
    type = string
}

variable "key_vault_name" {
    type = string
}

variable "hcp_provider_name" {
    type = string
}

# TODO: Reference locally
variable "hcp_project_id" {
    type = string
}

variable "hcp_service_principal_name" {
    type = string
}