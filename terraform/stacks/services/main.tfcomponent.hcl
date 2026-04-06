component "k8_cluster" {
  source = "app.terraform.io/amiasea/k8_cluster/github"
  version = "~> 1.0.0"

  inputs = {
    environment = var.environment
    rg_name     = var.rg_name
    location    = var.location
  }

  providers = { azurerm = provider.azurerm.main }
}

component "spire" {
  source = "app.terraform.io/amiasea/spire/github"
  version = "~> 1.0.0"
 
  inputs = {
    environment      = var.environment
    projects      = var.project_list
  }

  providers = {
    github = provider.github.main
  }
}