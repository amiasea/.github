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

  tenant_id       = var.azure_environment.context
  subscription_id = var.azure_environment.landing_zones.institutive

  use_oidc              = true
  client_id_file_path   = var.tfc_azure_dynamic_credentials.aliases["INSTITUTIVE"].client_id_file_path
  oidc_token_file_path  = var.tfc_azure_dynamic_credentials.aliases["INSTITUTIVE"].oidc_token_file_path

  features {}
}

provider "azurerm" {
  alias = "speculative"

  tenant_id       = var.azure_environment.context
  subscription_id = var.azure_environment.landing_zones.speculative

  use_oidc              = true
  client_id_file_path   = var.tfc_azure_dynamic_credentials.aliases["SPECULATIVE"].client_id_file_path
  oidc_token_file_path  = var.tfc_azure_dynamic_credentials.aliases["SPECULATIVE"].oidc_token_file_path

  features {}
}

provider "github" {
  owner = var.organization_name

  app_auth {
    pem_file = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
  }
}