data "azurerm_client_config" "current" {}

data "azurerm_subscriptions" "search" {
  display_name_prefix = "${var.prefix}-${var.env}"
}

# Gives Azure 60 seconds to "wake up" the new subscription
resource "time_sleep" "wait_for_sub" {
  create_duration = "60s"
  
  triggers = {
    subscription_id = local.target_sub_id
  }
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