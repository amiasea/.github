terraform {
  required_version = ">= 1.15.8"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.6.0"
    }
  }
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name         = "amiasea-github-app-private-key"
  key_vault_id = var.sovereign_azure_key_vault_id
}

ephemeral "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  name         = "amiasea-tfe-org-token"
  key_vault_id = var.sovereign_azure_key_vault_id
}

provider "azurerm" {
  tenant_id       = var.authority_azure_tenant_id
  client_id       = var.authority_azure_client_id
  subscription_id = var.sovereign_azure_subscription_id

  use_oidc = true

  features {}
}

# GITHUB_APP_ID & GITHUB_APP_INSTALLATION_ID env vars set
provider "github" {
  owner = var.organization_name

  app_auth {
    id              = var.amiasea_app_id
    installation_id = var.amiasea_app_installation_id
    pem_file        = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "amiasea"
  token        = ephemeral.azurerm_key_vault_secret.amiasea_tfe_org_token.value
}

provider "http" {}