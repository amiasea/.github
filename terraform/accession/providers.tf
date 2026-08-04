terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0"
    }
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

provider "azuread" {
  tenant_id = var.authority_azure_tenant_id
}

provider "azurerm" {
  tenant_id       = var.authority_azure_tenant_id

  features {}
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "amiasea"
}