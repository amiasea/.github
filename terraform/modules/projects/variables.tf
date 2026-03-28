variable "projects" {
    type = list(object({
        name = string,
        visibility = optional(string, "private")
    }))
}

variable "template_repo_name" {
    type = string
}