terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
    # azapi = {
    #   source  = "azure/azapi"
    #   version = "~> 2.10.0"
    # }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

provider "azuread" {
  tenant_id = var.tenant_id
  use_oidc  = true
}

provider "github" {
  owner = "amiasea"
}

# provider "azapi" {
#   subscription_id = var.subscription_id
#   skip_provider_registration = false
# }

provider "tfe" {
  hostname = "app.terraform.io"
  token = var.tfe_org_token
}

provider "http" {}