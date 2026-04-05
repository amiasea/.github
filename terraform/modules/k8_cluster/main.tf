resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                = "app-${var.environment}-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "app-${var.environment}"
  sku_tier            = "Free"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_B2s"

    os_disk_type    = "Ephemeral"
    os_disk_size_gb = 30
  }

  identity { type = "SystemAssigned" }
}