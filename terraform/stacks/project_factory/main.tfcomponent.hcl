component "genie" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  version = ">= 77.0.0" 

  inputs = {
    secret_name = "amiasea-github-private-key"
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "template" {
  source  = "app.terraform.io/amiasea/project_template_repo/github"
  version = ">= 86.0.0"

  providers = {
    github = provider.github.main
  }
}

component "factory" {
  source  = "app.terraform.io/amiasea/projects/github"
  version = ">= 82.0.0"

  inputs = {
    template_repo_name = component.template.repository_name
    projects           = var.project_list
  }
  providers = {
    github = provider.github.main
  }
}
