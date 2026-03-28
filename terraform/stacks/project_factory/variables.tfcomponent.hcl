variable "project_list" {
  type = list(object({
    name       = string
    visibility = optional(string, "private")
  }))
}

variable "gh_app_id" {
    type = string
}

variable "gh_app_installation" {
    type = string
}

variable "github_jwt" {
  type      = string
  ephemeral = true  # Mark as ephemeral for security in Stacks
}