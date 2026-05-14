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

variable "neon_project_id" {
    type = string
    default = "gentle-butterfly-81025773"
}

variable "k8_admin_group_id" {
    type = string
    sensitive = true
}