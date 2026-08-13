#Azure

## Alias is a subscription creation request identification

data "tfe_variable_set" "authority" {
  name         = "authority"
  organization = var.organization_name
}

check "environment_prerequisites" {
  assert {
    condition     = data.tfe_variable_set.authority.id != ""
    error_message = "Environment cannot run until Accession has created the Azure OIDC variable set."
  }
}

import {
  to = azurerm_subscription.sovereign
  id = "/providers/Microsoft.Subscription/aliases/amiasea-sovereign-alias"
}

resource "azurerm_subscription" "sovereign" {
  subscription_name = "amiasea-sovereign"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.amiasea.id
}

resource "azurerm_resource_group" "amiasea_sovereign" {
  provider = azurerm.amiasea-sovereign
  name     = "rg-amiasea-sovereign"
  location = "Central US"
}