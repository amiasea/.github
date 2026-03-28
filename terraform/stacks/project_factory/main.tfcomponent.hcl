variable "project_list" {
  type = list(object({
    name       = string
    visibility = optional(string, "private")
  }))
}

component "template" {
  source = "app.terraform.io/amiasea/project_template_repo/github"
  version = "~> 1.0.0"
}

component "factory" {
  source = "app.terraform.io/amiasea/projects/github"
  version = "~> 1.0.0"
  inputs = {
    template_name = component.template.outputs.repository_name
    projects      = var.project_list
  }
  providers = { github = provider.github.main }
}