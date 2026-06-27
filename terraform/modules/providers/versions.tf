terraform {
  required_version = ">= 1.15.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.12.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.78.0"
    }
  }
}
