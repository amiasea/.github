terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.1.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "speculative"
  features {}
  subscription_id = var.azure_speculative_subscription_id
}

provider "azapi" {}

provider "github" {
  owner = var.organization_name

  app_auth {
    pem_file = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}
