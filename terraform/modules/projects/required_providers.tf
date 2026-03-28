terraform {
  required_version = ">= 1.14.8"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.75.0"
    }
  }
}