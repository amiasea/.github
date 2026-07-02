# To force the Free tier in your code, explicitly specify the sku
resource "azurerm_app_configuration" "amiasea_config" {
  name                = "appcfg-amiasea"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "free"
}