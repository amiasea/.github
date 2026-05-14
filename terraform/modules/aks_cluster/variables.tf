variable "location" {
    type = string
}

variable "rg_name" {
    type = string
}

variable "environment" {
    type = string
}

variable "k8_admin_group_id" {
    type = string
    sensitive = true
    ephemeral = true
}