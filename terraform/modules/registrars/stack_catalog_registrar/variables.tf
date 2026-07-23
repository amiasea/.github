variable "stack_names" {
  type = list(string)
  description = "A list of stack names."

  validation {
      condition     = length(var.stack_names) == length(toset(var.stack_names))
      error_message = "The stack names list must contain unique elements; duplicates are not allowed."
  }
}

variable "tfe_pat" {
  type = string
}

variable "github_app_installation_id" {
  type = string
  description = "A GitHub App Installation ID"
}

variable "tfe_project_id" {
  type = string
  description = "A Terraform Cloud Project ID"
}