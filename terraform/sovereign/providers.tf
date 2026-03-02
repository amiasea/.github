terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Version 4.x has improved OIDC stability
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 6.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.60.0"
    }
  }
}

# --- Azure Provider ---
# Uses OIDC from the azure/login@v2 action via ARM_USE_OIDC=true
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # Ensure the provider respects the OIDC session
  use_oidc = true
}

provider "azuread" {
  use_oidc  = true
}

provider "github" {
  owner = "amiasea"
}
