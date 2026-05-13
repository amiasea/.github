terraform {
  required_version = ">= 1.14.3"

  required_providers {
    neon = {
      source  = "kislerdm/neon"
      version = "~> 0.13.0" # Latest stable version
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
  }
}