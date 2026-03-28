variable "project_name" { type = string }

# RECALL: This is the local relative path inside the bundle
component "network" {
  source = "./modules/bespoke-network"
  
  inputs = {
    vpc_name = "vnet-${var.project_name}"
  }

  providers = { azurerm = provider.azurerm.auth }
}