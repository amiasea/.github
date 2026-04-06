variable "rg_name" {
    type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "azure_oidc_token" {
    type = string
    ephemeral = true
}