terraform {
  required_version = ">= 1.15.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0"
    }
  }
}

provider "azuread" {
  use_cli = false
}