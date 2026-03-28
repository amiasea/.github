terraform {
  required_version = ">= 1.14.8"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 6.0"
    }
  }
}