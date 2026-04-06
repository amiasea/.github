required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
  neon = {
    source  = "kislerdm/neon"
    version = "~> 0.13.0"
  }
  kuberbetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 3.0.1"
  }
}

provider "kubernetes" "main" {
  host                   = component.k8_cluster.host
  client_certificate     = component.k8_cluster.client_certificate
  client_key             = component.k8_cluster.client_key
  cluster_ca_certificate = component.k8_cluster.cluster_ca_certificate
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
