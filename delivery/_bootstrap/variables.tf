variable "organization_name" {
  type    = string
  default = "amiasea"
}

variable "github_app_id" {
  type = string
  default = "2670685"
}

variable "github_app_installation_id" {
  type = string
  default = "105130264"
}

variable "amiasea_github_app_private_key" {
  type = string
  ephemeral = true
  sensitive = true
}