data "azurerm_key_vault" "sovereign_kv" {
  name                = "kv-amiasea-sovereign"
  resource_group_name = "rg-amiasea-sovereign"
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name         = "amiasea-github-app-private-key"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id
}

resource "azurerm_resource_group" "sovereign" {
  name = "rg-amiasea-sovereign"
  location = var.location
}

resource "azurerm_container_app_environment" "api" {
  name                = "amiasea-api"
  location            = azurerm_resource_group.sovereign.location
  resource_group_name = azurerm_resource_group.sovereign.name
}

data "azurerm_user_assigned_identity" "amiasea_workload" {
  name                = "amiasea-workload"
  resource_group_name = azurerm_resource_group.sovereign.name
}

# data "azuread_application" "amiasea_app" {
#   display_name = "amiasea-app"
# }

resource "azurerm_container_app" "api" {
  name                         = "amiasea-api"
  container_app_environment_id = azurerm_container_app_environment.api.id
  resource_group_name          = azurerm_resource_group.sovereign.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.amiasea_workload.id]
  }

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "api"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}