resource "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}