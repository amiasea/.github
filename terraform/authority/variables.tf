variable "resource_group_name" {
  type        = string
  description = "Resource group for all ARM-plane resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "dockerhub_username" {
  type        = string
  description = "Docker Hub username for pulling the API image."
}

variable "dockerhub_password" {
  type        = string
  sensitive   = true
  description = "Docker Hub password for pulling the API image."
}