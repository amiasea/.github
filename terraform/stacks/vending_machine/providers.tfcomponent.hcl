required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.5.0"
  }
  azapi = {
    source  = "Azure/azapi"
    version = "~> 2.8.0"
  }
  azuread = {
    source  = "hashicorp/azuread"
    version = "~> 3.8.0"
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

provider "azuread" "main"{
  config {
    use_oidc  = true
    oidc_token      = var.azure_oidc_token
  }
}

provider "random" "main"{
  # This is used to generate random suffixes for resource names to ensure uniqueness
}

provider "azapi" "main"{
  config {
    subscription_id = var.env_subscription_id
    skip_provider_registration = false
  }
}