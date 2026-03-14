terraform {
  required_version = ">= 1.14.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}


# 1. The Sovereign Provider (already logged in via OIDC)
provider "azurerm" {
  features {}
  # This uses your Sovereign Sub by default
}

provider "azurerm" {
  alias           = "sub"
  subscription_id = azurerm_subscription.subscription.subscription_id
  features {}
}

provider "azuread" {
  use_oidc  = true
}

provider "random" {
  # This is used to generate random suffixes for resource names to ensure uniqueness
}