data "azurerm_client_config" "current" {}

resource "azurerm_subscription" "subscription" {
  alias             = "${var.prefix}-${var.env}"
  subscription_name = "${var.prefix}-${var.env}"
  billing_scope_id  = var.sovereign_billing_scope_id
}

# Gives Azure 60 seconds to "wake up" the new subscription
resource "time_sleep" "wait_for_sub" {
  create_duration = "60s"
  depends_on      = [azurerm_subscription.subscription]
}

resource "azurerm_resource_group" "rg" {
  provider   = azurerm.sub
  name       = "rg-${var.prefix}-${var.env}"
  location   = var.location
  depends_on = [time_sleep.wait_for_sub]
}

resource "azurerm_user_assigned_identity" "uami" {
  provider            = azurerm.sub
  name                = "uami-${var.prefix}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_role_assignment" "terraform_kv_admin" {
  scope                = var.sovereign_key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}