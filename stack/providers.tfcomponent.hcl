required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 3.0" # or your preferred version
  }
}

provider "azurerm" "auth" {
  config {
    features {}
    use_oidc = true
  }
  
  # This uses the token to authenticate the SPN the Factory minted
  # use_oidc        = true
  # client_id       = var.azure_client_id
  # tenant_id       = var.azure_tenant_id
  # subscription_id = var.azure_subscription_id
}
