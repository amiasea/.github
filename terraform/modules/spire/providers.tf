terraform {
  required_version = ">= 1.15.3"

  required_providers {
    neon = {
      source  = "kislerdm/neon"
      version = "~> 0.13.0" # Latest stable version
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16.0"
    }
  }
}