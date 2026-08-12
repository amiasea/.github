#Azure

## Alias is a subscription creation request identification

resource "azurerm_subscription" "sovereign" {
  subscription_name = "amiasea-sovereign"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.amiasea.id
  
}

# Put rg- before the name
resource "azurerm_resource_group" "amiasea_sovereign" {
  name     = "amiasea-sovereign-rg"
  location = "Central US"
}