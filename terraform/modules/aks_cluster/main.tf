resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                = "app-${var.environment}-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "app-${var.environment}"
  sku_tier            = "Free"
  automatic_upgrade_channel = "none"   # or "patch"


  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = var.vm_size
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
    os_disk_type    = var.os_disk_type
    os_disk_size_gb = var.os_disk_size_gb

    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.16.0.0/16"
    dns_service_ip     = "172.16.0.10"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  local_account_disabled     = false
  azure_policy_enabled       = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }

  lifecycle {
    ignore_changes = [
      kube_config,
      kube_config_raw,
      kube_admin_config,
      kube_admin_config_raw,
      default_node_pool[0].upgrade_settings,
      windows_profile,
    ]
  }

  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_subnet.aks_subnet
  ]
}

# resource "azapi_resource_action" "get_aks_token" {
#   type        = "Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31"
#   resource_id = azurerm_user_assigned_identity.uami.id
#   action      = "listAssociatedResources" # Handled natively by Azure to generate a scoped JWT

#   # We request a token specifically for the universal AKS Application ID
#   body = {
#     scope = "6dae42f8-4368-4678-94ff-3960e28e3630/.default"
#   }
# }

# resource "azurerm_federated_identity_credential" "stack_runner_trust" {
#   name                = "fic-stack-runner-${var.environment}"
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = "https://hashicorp.cloud"
#   subject             = "organization:amiasea:project:*:stack:*:deployment:*:operation:*"
#   parent_id           = azurerm_user_assigned_identity.uami.id
# }

resource "azurerm_user_assigned_identity" "uami" {
  name                = "uami-k8-cluster-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_subnet.aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
  
  # Helps avoid "PrincipalNotFound" errors during fast deployments
  skip_service_principal_aad_check = true
}
