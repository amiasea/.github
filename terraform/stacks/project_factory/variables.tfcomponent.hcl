variable "project_list" {
  type = list(object({
    name       = string
    visibility = optional(string, "private")
  }))
}