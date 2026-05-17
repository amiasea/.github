component "genie" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  version = ">= 64.0.0" 

  inputs = {
    secret_name = "neon-org-api-key"
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "aks_cluster" {
  source  = "app.terraform.io/amiasea/aks_cluster/github"
  version = ">= 47.0.0"

  inputs = {
    environment       = var.environment
    rg_name           = var.rg_name
    location          = var.location
    k8_admin_group_id = var.k8_admin_group_id
    vm_size           = var.vm_size
    os_disk_type      = var.os_disk_type
    os_disk_size_gb   = var.os_disk_size_gb
  }
  providers = {
    azurerm           = provider.azurerm.scoped_sub
  }
}

component "spire" {
  source  = "app.terraform.io/amiasea/spire/github"
  version = ">= 43.0.0"

  inputs = {
    environment     = var.environment
    neon_project_id = var.neon_project_id
  }
  providers = {
    kubernetes = provider.kubernetes.main
    neon       = provider.neon.main
  }
}
