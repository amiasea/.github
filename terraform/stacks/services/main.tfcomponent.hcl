component "genie" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  # TRACKS LATEST V18: Pulls your newest v18.x releases automatically
  version = ">= 20.0.0, < 21.0.0" 

  inputs = {
    secret_name = "neon-org-api-key"
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "aks_cluster" {
  source  = "app.terraform.io/amiasea/aks_cluster/github"
  # TRACKS LATEST V7: Pulls your newest v7.x releases automatically
  version = ">= 8.0.0, < 9.0.0"

  inputs = {
    environment       = var.environment
    rg_name           = var.rg_name
    location          = var.location
    k8_admin_group_id = var.k8_admin_group_id
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "spire" {
  source  = "app.terraform.io/amiasea/spire/github"
  # TRACKS LATEST V1: Pulls your newest v1.x releases automatically
  version = ">= 3.0.0, < 4.0.0"

  inputs = {
    environment     = var.environment
    neon_project_id = var.neon_project_id
  }
  providers = {
    kubernetes = provider.kubernetes.main
    neon       = provider.neon.main
  }
}
