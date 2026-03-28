variable "project_list" {
  type = list(object({
    name       = string
    visibility = optional(string, "private")
  }))
}

variable "gh_app_id" {
  type = string
  default = "2670685"
}

variable "gh_app_installation" {
  type = string
  default = "105130264"
}

variable "gh_app_pem_file" {
  type      = string
  sensitive = true
  ephemeral = true # Won't be stored in state
}