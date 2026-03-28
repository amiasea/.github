variable "vpc_name" { type = string }

resource "azurerm_virtual_network" "this" {
  name                = var.vpc_name
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "rg-${var.vpc_name}"
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}
