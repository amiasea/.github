component "template" {
  source = "app.terraform.io/amiasea/project_template_repo/github"
  version = "~> 1.0.0"

  providers = { github = provider.github.main }
}

component "factory" {
  source = "app.terraform.io/amiasea/projects/github"
  version = "~> 1.0.0"

  inputs = {
    template_repo_name = component.template.outputs.repository_name
    projects      = var.project_list
  }

  providers = { github = provider.github.main }
}