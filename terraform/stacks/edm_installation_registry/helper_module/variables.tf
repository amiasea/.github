variable "amiasea_gh_app_id" {
  type = string
}

variable "amiasea_gh_app_private_key" {
  type      = string
  sensitive = true
}

variable "github_installation_id" {
  type = string
}