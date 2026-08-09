terraform {
  required_version = ">= 1.15.8"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
  }
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.organization_name
}

provider "github" {
  owner = var.organization_name
}