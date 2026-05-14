terraform {
  required_version = ">= 1.15.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      configuration_aliases = [ azurerm.scoped_sub ] # Acts as a blank proxy variable
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
  }
}