terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    tfe = {
      source = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    azapi = {
        source = "azure/azapi"
        version = "~> 2.11.0"
    }
  }
}