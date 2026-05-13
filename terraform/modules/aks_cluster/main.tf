resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                = "app-${var.environment}-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "app-${var.environment}"
  sku_tier            = "Free"

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_B2s"
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
    os_disk_type    = "Ephemeral"
    os_disk_size_gb = 30
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }

  # Required to allow high-privilege host paths for the SPIRE Agent
  azure_policy_enabled = true

  local_account_disabled = true

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true # Allows using Azure IAM for K8s permissions
    admin_group_object_ids = [var.k8_admin_group_id]
  }

  depends_on = [azurerm_role_assignment.network_contributor]
}

resource "azurerm_user_assigned_identity" "uami" {
  name                = "uami-k8-cluster-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
  
  # Helps avoid "PrincipalNotFound" errors during fast deployments
  skip_service_principal_aad_check = true
}
