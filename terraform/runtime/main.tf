resource "azurerm_container_app_environment" "main" {
  name                = "cae-amiasea-aviator"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_container_app" "aviator_api" {
  name                         = "ca-amiasea-aviator-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_read_id]
  }

  template {
    min_replicas = 0
    max_replicas = 1

    http_scale_rule {
      name                = "http-auto-scale"
      concurrent_requests = "10"
    }

    container {
      name   = "amiasea-api"
      image  = "ghcr.io/amiasea/amiasea-api:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = var.uami_read_client_id
      }
    }
  }

  secret {
    name                = "ghcr-pat"
    key_vault_secret_id = "https://kv-amiasea.vault.azure.net/secrets/ghcr-pat" # Use versionless URL for latest
    identity            = var.uami_read_id
  }

  registry {
    server               = "ghcr.io"
    username             = "AlfredoBall"
    password_secret_name = "ghcr-pat"
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # IMPORTANT: Terraform will try to replace this if the value changes in KV
  lifecycle {
    ignore_changes = [
      secret,
      template[0].container[0].image,
    ]
  }
}

resource "azurerm_container_app" "aviator_ui" {
  name                         = "ca-amiasea-aviator-ui"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_read_id]
  }

  template {
    min_replicas = 0
    max_replicas = 1

    http_scale_rule {
      name                = "http-auto-scale"
      concurrent_requests = "10"
    }

    container {
      name   = "amiasea-api"
      image  = "docker.io/library/alpine:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = var.uami_read_client_id
      }
    }
  }

  secret {
    name                = "ghcr-pat"
    key_vault_secret_id = "https://kv-amiasea.vault.azure.net/secrets/ghcr-pat" # Use versionless URL for latest
    identity            = var.uami_read_id
  }

  registry {
    server               = "ghcr.io"
    username             = "AlfredoBall"
    password_secret_name = "ghcr-pat"
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # IMPORTANT: Terraform will try to replace this if the value changes in KV
  lifecycle {
    ignore_changes = [
      secret,
      template[0].container[0].image,
    ]
  }
}