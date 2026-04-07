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
    neon = {
      source  = "kislerdm/neon"
      version = "~> 0.13.0" # Latest stable version
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
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