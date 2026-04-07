component "genie" {
  source = "app.terraform.io/amiasea/whisper_genie/github"
  version = "~> 5.0.0"

  inputs = {
    secret_name = "neon-org-api-key"
  }

  providers = { azurerm = provider.azurerm.main }
}

component "aks_cluster" {
  source = "app.terraform.io/amiasea/aks_cluster/github"
  version = "~> 1.0.0"

  inputs = {
    environment = var.environment
    rg_name     = var.rg_name
    location    = var.location
    k8_admin_group_id = var.k8_admin_group_id
  }

  providers = { azurerm = provider.azurerm.main }
}

component "spire" {
  source = "app.terraform.io/amiasea/spire/github"
  version = "~> 1.0.0"
 
  inputs = {
    environment = var.environment
    neon_project_id = var.neon_project_id
  }

  providers = {
    kubernetes = provider.kubernetes.main
  }
}