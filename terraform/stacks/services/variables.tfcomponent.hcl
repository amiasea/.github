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
    sensitive = true
    ephemeral = true
}

variable "env_subscription_id" { type = string }

variable "neon_project_id" {
    type = string
    default = "gentle-butterfly-81025773"
}

variable "k8_admin_group_id" {
    type = string
    sensitive = true
}

variable "vm_size" {
    type = string
}

variable "os_disk_type" {
    type = string
}

variable "os_disk_size_gb" {
    type = number
}