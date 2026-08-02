data "azurerm_resource_group" "amiasea_sovereign_rg" {
  name     = var.resource_group_name
  location = var.location
}

# ENVIRONMENT RESOURCE GROUPS