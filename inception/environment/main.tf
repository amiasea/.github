#Azure

## Alias is a subscription creation request identification

resource "azurerm_subscription" "sovereign" {
  subscription_name = "amiasea-sovereign-test-1"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.amiasea.id
}

resource "azurerm_resource_group" "amiasea_sovereign" {
  provider = azurerm.amiasea-sovereign
  name     = "rg-amiasea-sovereign"
  location = "Central US"
}