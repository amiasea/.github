required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
  neon = {
    source  = "kislerdm/neon"
    version = "~> 0.13.0"
  }
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 3.0.1"
  }
}

provider "kubernetes" "main" {
  config {
    host                   = component.aks_cluster.host
    cluster_ca_certificate = base64decode(component.aks_cluster.cluster_ca_certificate)
    client_certificate     = base64decode(component.aks_cluster.client_certificate)
    client_key             = base64decode(component.aks_cluster.client_key)
  }
}

provider "azurerm" "main" {
  config {
    use_oidc        = true
    subscription_id = "da348b35-29b6-4906-85ec-4a097aa5fe04"
    client_id       = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf"
    tenant_id       = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    oidc_token      = var.azure_oidc_token

    features {
    }
  }
}

provider "azurerm" "scoped_sub" {
  config {
    use_oidc        = true
    subscription_id = var.env_subscription_id
    client_id       = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf" # Uses the same App Registration identity
    tenant_id       = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    oidc_token      = var.azure_oidc_token
    features {}
  }
}

provider "neon" "main" {
  config {
    api_key = component.genie.secret_value
  }
}