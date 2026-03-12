# 1. The Sovereign Provider (already logged in via OIDC)
provider "azurerm" {
  features {}
  # This uses your Sovereign Sub by default
}

provider "azurerm" {
  alias           = "sub"
  subscription_id = azurerm_subscription.subscription.subscription_id
  features {}
}