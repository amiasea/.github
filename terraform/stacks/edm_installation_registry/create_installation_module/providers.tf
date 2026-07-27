terraform {
  required_version = ">= 1.15.8"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
    tfe = {
      source = "hashicorp/tfe"
      version = "~> 0.79.0"
    }
  }
}