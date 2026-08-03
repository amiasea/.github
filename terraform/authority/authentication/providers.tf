terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
  }
}