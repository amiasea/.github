component "genie" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  # TRACKS LATEST V18: Pulls your newest v18.x releases automatically
  version = ">= 26.0.0" 

  inputs = {
    secret_name = "amiasea-github-private-key"
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "template" {
  source  = "app.terraform.io/amiasea/project_template_repo/github"
  # TRACKS LATEST V27: Pulls your newest v27.x releases automatically
  version = ">= 35.0.0"

  providers = {
    github = provider.github.main
  }
}

component "factory" {
  source  = "app.terraform.io/amiasea/projects/github"
  # TRACKS LATEST V23: Pulls your newest v23.x releases automatically
  version = ">= 31.0.0"

  inputs = {
    template_repo_name = component.template.repository_name
    projects           = var.project_list
  }
  providers = {
    github = provider.github.main
  }
}
