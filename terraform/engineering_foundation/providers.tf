terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.authority_azure_tenant_id
  subscription_id = var.sovereign_azure_subscription_id

  use_cli  = false
  use_oidc = true

  features {}
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "amiasea"
  token        = ephemeral.azurerm_key_vault_secret.amiasea_tfe_org_token.value
}

provider "github" {
  owner = "amiasea"

  app_auth {
    id              = "2670685"
    installation_id = "105130264"
    pem_file        = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}
