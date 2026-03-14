resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.sub
  name                = "vnet-${var.prefix}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [local.vended_cidr]
}

resource "azurerm_subnet" "subnet" {
  provider             = azurerm.sub
  name                 = "snet-${var.prefix}-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  # It takes the full 10.X.0.0/16 range
  address_prefixes = [local.vended_cidr]

  # Bonus: Enable Service Endpoints here if needed
  service_endpoints = ["Microsoft.KeyVault", "Microsoft.Sql"]

  delegation {
    name = "aca_delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# SQL: Only allow the ACA Subnet
resource "azurerm_mssql_virtual_network_rule" "sql_vnet_rule" {
  name      = "aca-to-sql"
  server_id = azurerm_mssql_server.sql.id
  subnet_id = azurerm_subnet.subnet.id
}