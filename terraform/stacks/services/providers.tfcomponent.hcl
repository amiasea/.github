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
    client_certificate     = component.aks_cluster.client_certificate
    client_key             = component.aks_cluster.client_key
    cluster_ca_certificate = component.aks_cluster.cluster_ca_certificate
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

provider "azurerm" "dev_subscription" {
  config {
    use_oidc        = true
    subscription_id = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b" 
    client_id       = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf" # Uses the same App Registration identity
    tenant_id       = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    oidc_token      = var.azure_oidc_token
    features {}
  }
}

provider "azurerm" "prod_subscription" {
  config {
    use_oidc        = true
    subscription_id = "d9cd6518-e401-4072-a410-a6a67e9b15f6" 
    client_id       = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf" # Uses the same App Registration identity
    tenant_id       = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    oidc_token      = var.azure_oidc_token
    features {}
  }
}

provider "azurerm" "scoped_sub" {
  config {
    features {}
  }   # intentionally empty — will be overridden by the deployment
}

provider "neon" "main" {
  config {
    api_key = component.genie.secret_value
  }
}