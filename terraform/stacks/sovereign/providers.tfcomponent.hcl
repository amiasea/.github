required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.0"
  }
}

provider "azurerm" "main" {
  config {
    use_oidc = true
    subscription_id = var.sovereign_azure_subscription_id
    tenant_id       = var.sovereign_azure_tenant_id
    client_id       = var.sovereign_azure_client_id
    oidc_token      = var.azure_oidc_token

    features {}
  }
}