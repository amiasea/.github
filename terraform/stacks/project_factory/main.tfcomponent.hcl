component "genie" {
  source = "app.terraform.io/amiasea/whisper_genie/github"
  version = "~> 2.0.0"

  inputs = {
    secret_name = "amiasea-github-private-key"
  }

  providers = { azurerm = provider.azurerm.main }
}

component "template" {
  source = "app.terraform.io/amiasea/project_template_repo/github"
  version = "~> 7.0.0"

  providers = { github = provider.github.main }
}

component "factory" {
  source = "app.terraform.io/amiasea/projects/github"
  version = "~> 3.0.0"
 
  inputs = {
    template_repo_name = component.template.repository_name
    projects      = var.project_list
  }

  providers = {
    github = provider.github.main
    # tfe    = provider.tfe.main
  }
}