resource "aurerm_resource_group" "sovereign" {
  name = "rg-amiasea-sovereign"
}

resource "azurerm_container_app_environment" "api" {
  name                = "amiasea-api"
  location            = azurerm_resource_group.sovereign.location
  resource_group_name = azurerm_resource_group.sovereign.name
}

data "azurerm_user_assigned_identity" "amiasea_authority" {
  name                = "Amiasea-Authority"
  resource_group_name = azurerm_resource_group.sovereign.name
}

data "azuread_service_principal" "amiasea_authority" {
  display_name = "Amiasea-Authority"
}

resource "azurerm_container_app" "api" {
  name                         = "amiasea-api"
  container_app_environment_id = azurerm_container_app_environment.api.id
  resource_group_name          = azurerm_resource_group.sovereign.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azuread_service_principal.amiasea_authority.id]
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