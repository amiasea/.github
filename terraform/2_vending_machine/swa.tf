resource "azurerm_static_web_app" "aviator_ui" {
  provider            = azurerm.sub
  name                = "swa-${var.prefix}-ui-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku_tier            = "Free"
}