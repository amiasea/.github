terraform {
  required_version = ">= 1.14.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8.0"
    }
  }
}

provider "azuread" {
  alias     = "prod_ciam"
  tenant_id = var.tenant_id
}