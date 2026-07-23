locals {
  envs = ["dev", "prod"]
}

resource "azurerm_subscription" "subscription" {
  # toset() converts the list into a map Terraform can track
  for_each = toset(local.envs)

  # each.key will be "dev", then "prod"
  alias             = "${var.prefix}-${each.key}"
  subscription_name = "${var.prefix}-${each.key}"
  
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing_scope.id
}

resource "azurerm_role_assignment" "delegated_permissions_subscription_owner" {
  for_each = azurerm_subscription.subscription

  scope                = "/subscriptions/${each.value.subscription_id}"
  
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
  
  skip_service_principal_aad_check = true 
}