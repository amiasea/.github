terraform {
  required_version = ">= 1.15.8"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.80.0"
    }
  }
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.organization_name
}