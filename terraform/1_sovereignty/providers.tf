terraform {
  required_version = ">= 1.14.3"

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
      source  = "hashicorp/github"
      version = "~> 6.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.8.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.74.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    subscription {
      prevent_cancellation_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {
  use_oidc  = true
}

provider "github" {
  owner = "amiasea"
}

provider "azapi" {
  subscription_id = var.subscription_id
  skip_provider_registration = false
}

provider "tfe" {
  hostname = "app.terraform.io"
}