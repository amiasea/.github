terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

provider "azurerm" {
  alias           = "amiasea-sovereign"
  subscription_id = azurerm_subscription.sovereign.subscription_id

  use_oidc = true

  features {}
}