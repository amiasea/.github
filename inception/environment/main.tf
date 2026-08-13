#Azure

## Alias is a subscription creation request identification

resource "azurerm_subscription" "sovereign" {
  subscription_name = "amiasea-sovereign-test-2"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.amiasea.id
}

resource "azapi_resource" "amiasea_sovereign" {
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  name      = "rg-amiasea-sovereign"
  location  = "Central US"
  parent_id = "/subscriptions/${azurerm_subscription.sovereign.subscription_id}"

  body = {
    properties = {}
  }
}

# resource "azurerm_resource_group" "amiasea_sovereign" {
#   provider = azurerm.amiasea-sovereign
#   name     = "rg-amiasea-sovereign"
#   location = "Central US"
# }