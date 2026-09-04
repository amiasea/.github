terraform {
  required_version = ">= 1.15.8"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.80.0"
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

  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.amiasea_github_app_private_key
  }
}