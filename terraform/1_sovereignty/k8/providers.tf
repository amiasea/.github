terraform {
  required_version = ">= 1.14.3"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0" # Version 4.x has improved OIDC stability
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 6.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.8.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.74.1"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.1.0" # Or current latest
    }
    neon = {
      source  = "kislerdm/neon"
      version = "~> 0.13.0" # Latest stable version
    }
    kuberbetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
  }
}

provider "azuread" {
  use_oidc  = true

}

provider "github" {
  owner = "amiasea"
}

provider "azapi" {
  subscription_id = var.subscription_id
  skip_provider_registration = false
}

provider "tfe" {
  hostname = "app.terraform.io"
}

provider "terracurl" {}

provider "neon" {}

# Prod Provider
# provider "kubernetes" {
#   alias = "prod"
#   host  = azurerm_kubernetes_cluster.platform["prod"].kube_config.0.host
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.platform["prod"].kube_config.0.client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.platform["prod"].kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.platform["prod"].kube_config.0.cluster_ca_certificate)
# }