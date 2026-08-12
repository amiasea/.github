terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "amiasea"

  token = ephemeral.azurerm_key_vault_secret.amiasea_tfe_org_token.value
}

provider "github" {
  owner = var.organization_name

  app_auth {
    pem_file = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}
