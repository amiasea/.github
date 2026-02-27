terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # github = {
    #   source  = "integrations/github"
    #   version = "~> 6.0"
    # }
  }
}

provider "azurerm" {
  features {}
}

# provider "github" {
#   owner = "amiasea"
# }