data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  provider   = azurerm.sub
  name       = "rg-${var.prefix}-${var.env}"
  location   = var.location
}

resource "azurerm_user_assigned_identity" "uami" {
  provider            = azurerm.sub
  name                = "uami-${var.prefix}-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
}