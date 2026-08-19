terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.1.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.80.0"
    }
  }
}

provider "azuread" {}

provider "azapi" {}

provider "azurerm" {
  features {}
}

provider "tfe" {
  organization = var.organization_name
}