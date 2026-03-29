variable "project_list" {
  type = list(object({
    name       = string
    visibility = optional(string, "private")
  }))
}

variable "azure_oidc_token" {
    type = string
}

variable "gh_app_id" {
  type = string
  default = "2670685"
}

variable "gh_app_installation" {
  type = string
  default = "105130264"
}

variable "gh_app_pem_key" {
  type      = string
  ephemeral = true # Won't be stored in state
}