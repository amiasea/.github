terraform {
  required_version = ">= 1.15.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0" 
    }
  }
}