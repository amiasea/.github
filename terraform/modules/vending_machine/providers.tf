terraform {
  required_version = ">= 1.14.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0"
      configuration_aliases = [azurerm.sub]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.8.0"
    }
  }
}