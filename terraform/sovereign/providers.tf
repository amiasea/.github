terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Version 4.x has improved OIDC stability
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.100.0" 
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

# --- HCP Provider ---
# Manages Projects, Service Principals, and Workload Identity
# Uses the TFE_TOKEN (or HCP_ACCESS_TOKEN) from hcp-auth-action
provider "hcp" {}

# --- TFE Provider ---
# Specifically for generating the Sovereign Team Token
# This relies on the TFE_TOKEN environment variable mapped in your workflow
provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.tfe_organization
}
