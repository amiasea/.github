terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.1.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
  }
}

provider "azurerm" {
  alias = "institutive"
  tenant_id = var.azure_environment.context
  client_id = var.azure_environment.authority_principal.institutive
  subscription_id = var.azure_environment.landing_zones.institutive

  features {}
}

provider "azurerm" {
  alias = "speculative"
  tenant_id = var.azure_environment.context
  client_id = var.azure_environment.authority_principal.speculative
  subscription_id = var.azure_environment.landing_zones.speculative

  features {}
}

provider "github" {
  owner = var.organization_name

  app_auth {
    pem_file = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}